import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as sa;
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

import '../../../../const/app_bundle_info.dart';
import '../../../../models/api_exception/api_exception.dart';
import '../../../../models/push_tokens/push_token.dart';
import '../../../../models/user/user_data.dart';
import '../../../../shared/enums/device.dart';
import '../../../../shared/enums/social_logins.dart';
import '../../../../shared/enums/token_type.dart';
import '../../../../shared/util/firebase_collections.dart';
import 'auth_db_ab.dart';

class AuthDatabase implements AuthDB {
  const AuthDatabase({
    required this.firebaseAuth,
    required this.firebaseMessaging,
    required this.googleSignIn,
    required this.facebookAuth,
  });
  final FirebaseAuth firebaseAuth;
  final FirebaseMessaging firebaseMessaging;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookAuth;

  @override
  Future<void> saveDeviceTokenToDatabase(User user, String token) async {
    final PushToken pushToken = PushToken(
      token: token,
      created_at: DateTime.now().millisecondsSinceEpoch,
      device: Platform.isAndroid ? DeviceOS.android : DeviceOS.ios,
      type: TokenType.FCM,
    );

    await usersCollectionRef.doc(user.uid).update(<String, dynamic>{
      'tokens':
          FieldValue.arrayUnion(<Map<String, dynamic>>[pushToken.toJson()]),
      'lastTokenUpdate': DateTime.now(),
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  void updateTokenWhenRefreshed(User user) {
    firebaseMessaging.onTokenRefresh.listen((String refreshedToken) async {
      await saveDeviceTokenToDatabase(user, refreshedToken);
      await subscribeToTopics();
    });
  }

  // Subcribe to topics
  @override
  Future<void> subscribeToTopics() async {
    await firebaseMessaging.subscribeToTopic('chases');
  }

  //sign out
  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    await facebookAuth.logOut();
  }

  @override
  Stream<User?> streamLogInStatus() {
    return firebaseAuth.authStateChanges();
  }

  @override
  Stream<UserData> streamUserData(String? uid) {
    log(firebaseAuth.currentUser?.email ?? '');
    final Stream<DocumentSnapshot<UserData>> snapshot =
        usersCollectionRef.doc(uid).snapshots();

    return snapshot.map((DocumentSnapshot<UserData> e) {
      if (e.data() != null) {
        return e.data()!;
      } else {
        throw UnimplementedError();
      }
    });
  }

  @override
  Future<void> googleLogin() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final fauth.AuthCredential credential = fauth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    await firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> socialLogin(SIGNINMETHOD loginmethods) async {
    switch (loginmethods) {
      case SIGNINMETHOD.Google:
        await googleLogin();
        break;

      case SIGNINMETHOD.Apple:
        await appleLogin();
        break;
      case SIGNINMETHOD.Facebook:
        await facebookLogin();
        break;
      case SIGNINMETHOD.Twitter:
        await twitterLogin();
        break;
      // case SIGNINMETHOD.Email:
      //   await emailLogin();
      //   break;
      default:
    }
  }

  @override
  Future<UserData> createUser(User user) async {
    final DocumentReference<UserData> docRef = usersCollectionRef.doc(user.uid);
    try {
      final UserData userData = UserData(
        uid: user.uid,
        userName: user.displayName,
        //TODO: Should we allow facebook login that doesn't have email?
        email: user.email,
        photoURL: user.photoURL,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
      );
      await docRef.set(userData);

      return userData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserData> fetchUser(User user) async {
    final DocumentReference<UserData> docRef = usersCollectionRef.doc(user.uid);
    try {
      final DocumentSnapshot<UserData> document = await docRef.get();

      if (document.data() != null) {
        return document.data()!;
      } else {
        throw UnimplementedError();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserData> fetchOrCreateUser(User user) async {
    final DocumentReference<UserData> docRef = usersCollectionRef.doc(user.uid);
    try {
      final DocumentSnapshot<UserData> document = await docRef.get();

      if (document.exists) {
        if (document.data() != null) {
          return document.data()!;
        } else {
          throw ChaseAppCallException(
            message: 'User found but user data is null.',
          );
        }
      } else {
        return await createUser(user);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> appleLogin() async {
    try {
      final sa.AuthorizationCredentialAppleID appleSignIn =
          await sa.SignInWithApple.getAppleIDCredential(
        scopes: <sa.AppleIDAuthorizationScopes>[
          sa.AppleIDAuthorizationScopes.email,
          sa.AppleIDAuthorizationScopes.fullName,
        ],
      );
      final fauth.AuthCredential credential = fauth.OAuthProvider('apple.com')
          .credential(idToken: appleSignIn.identityToken);

      await firebaseAuth.signInWithCredential(credential);
    } on sa.SignInWithAppleAuthorizationException catch (e) {
      if (e.code != sa.AuthorizationErrorCode.canceled) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> facebookLogin() async {
    late final LoginResult loginResult;
    late final OAuthCredential facebookAuthCredential;

    loginResult = await facebookAuth.login();

    if (loginResult.status == LoginStatus.cancelled) {
      return;
    }

    // Create a credential from the access token
    facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    await firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  @override
  Future<void> handleMutliProviderSignIn(
    SIGNINMETHOD signinmethod,
    AuthCredential providerOAuthCredential,
  ) async {
    await socialLogin(signinmethod);

    await firebaseAuth.currentUser!.linkWithCredential(providerOAuthCredential);
  }

  @override
  Future<void> twitterLogin() async {
    // Create a TwitterLogin instance

    final TwitterLogin twitterLogin = TwitterLogin(
      apiKey: EnvVaribales.twitterApiKey,
      apiSecretKey: EnvVaribales.twitterSecretKey,
      redirectURI: 'social-firebase-auth://',
    );

    // Trigger the sign-in flow
    final AuthResult authResult = await twitterLogin.login();

    if (authResult.status == TwitterLoginStatus.cancelledByUser) {
      return;
    }
    // Create a credential from the access token
    final OAuthCredential twitterAuthCredential =
        TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );

    await firebaseAuth.signInWithCredential(twitterAuthCredential);
  }

  @override
  Future<void> sendSignInLinkToEmail(String email) async {
    await firebaseAuth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: AppBundleInfo.dynamicLinkHostUrl(
          true,
        ), // "https://carverauto.page.link/",
        handleCodeInApp: true,
        iOSBundleId:
            AppBundleInfo.iosBundleId, //'com.carverauto.chaseapp.cdev',
        androidPackageName:
            AppBundleInfo.androidBundleId, // 'com.carverauto.chasedev',
        androidInstallApp: true,
        androidMinimumVersion: '0',
      ),
    );
  }

  @override
  Future<void> signInWithEmailAndLink(String email, String link) async {
    await firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    final String projectId = firebaseAuth.app.options.projectId;
    final String apiKey = EnvVaribales.getGCPServerApiKey;
    final Uri url = Uri.parse(
      'https://us-central1-$projectId.cloudfunctions.net/DeleteUser',
    );

    final http.Response responce = await http.post(
      url,
      headers: {
        'X-ApiKey': apiKey,
      },
      body: jsonEncode({
        'id': userId,
      }),
    );

    log(responce.body);

    // final Map<String, dynamic> decodedData =
    //     jsonDecode(responce.body) as Map<String, dynamic>;
  }
}
