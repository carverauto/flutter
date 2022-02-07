import 'dart:async';
import 'dart:io';

import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/core/modules/auth/data/auth_db_ab.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/push_tokens/push_token.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/enums/device.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as sa;
import 'package:twitter_login/twitter_login.dart';

class AuthDatabase implements AuthDB {
  AuthDatabase({
    required this.read,
  });
  final Reader read;

  Future<void> saveFirebaseDeviceToken(User user) async {
    String? token = await read(firebaseMesssagingProvider).getToken();
    if (token != null) {
      saveTokenToDatabase(user, token);
    }
  }

  Future<void> saveTokenToDatabase(User user, String token) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    final pushToken = PushToken(
      Token: token,
      CreatedAt: DateTime.now().millisecondsSinceEpoch,
      Device: Platform.isAndroid ? Device.ANDROID : Device.IOS,
      TokenType: TokenType.FCM,
    );

    await usersCollectionRef.doc(userId).update({
      'pushTokens': FieldValue.arrayUnion(<PushToken>[pushToken]),
      'tokens': FieldValue.arrayUnion(<String>[token]),
      "photoURL": user.photoURL,
      "userName": user.displayName,
      'lastTokenUpdate': DateTime.now(),
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void updateTokenWhenRefreshed(User user) {
    read(firebaseMesssagingProvider).onTokenRefresh.listen((token) {
      saveTokenToDatabase(user, token);
      subscribeToTopics();
    });
  }

  // Subcribe to topics
  Future<void> subscribeToTopics() async {
    await read(firebaseMesssagingProvider).subscribeToTopic("chases");
  }

  //sign out
  @override
  Future<void> signOut() async {
    await read(googleSignInProvider).signOut();
    await read(firebaseAuthProvider).signOut();
    await read(facebookSignInProvider).logOut();
  }

  @override
  Stream<User?> streamLogInStatus() {
    // TODO: implement streamLogInStatus
    return read(firebaseAuthProvider).authStateChanges();
  }

  @override
  Stream<UserData> streamUserData(String uid) {
    final snapshot = usersCollectionRef.doc(uid).snapshots();

    return snapshot.map((e) {
      if (e.data() != null) {
        return e.data()!;
      } else {
        throw UnimplementedError();
      }
    });
  }

  @override
  Future<void> googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser == null) {
      return;
    }

    GoogleSignInAuthentication? _googleAuth = await _googleUser.authentication;
    final fauth.AuthCredential credential = fauth.GoogleAuthProvider.credential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

    await read(firebaseAuthProvider).signInWithCredential(credential);
  }

  @override
  Future<void> socialLogin(SIGNINMETHOD loginmethods) async {
    switch (loginmethods) {
      case SIGNINMETHOD.GOOGLE:
        await googleLogin();
        break;

      case SIGNINMETHOD.APPLE:
        await appleLogin();
        break;
      case SIGNINMETHOD.FACEBOOK:
        await facebookLogin();
        break;
      case SIGNINMETHOD.TWITTER:
        await twitterLogin();
        break;
      default:
    }
  }

  @override
  Future<UserData> createUser(User user) async {
    final DocumentReference<UserData> docRef = usersCollectionRef.doc(user.uid);
    try {
      await docRef.set(
        UserData(
          uid: user.uid,
          userName: user.displayName ?? "NA",
          email: user.email!,
          photoURL: user.photoURL ?? defaultPhotoURL,
          lastUpdated: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      return await fetchUser(user);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<UserData> fetchUser(User user) async {
    final DocumentReference<UserData> docRef = usersCollectionRef.doc(user.uid);
    try {
      final document = await docRef.get();

      if (document.data() != null) {
        return document.data()!;
      } else {
        throw UnimplementedError();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserData> fetchOrCreateUser(User user) async {
    final DocumentReference<UserData> docRef = usersCollectionRef.doc(user.uid);
    try {
      final document = await docRef.get();

      if (document.exists) {
        if (document.data() != null) {
          return document.data()!;
        } else {
          throw UnimplementedError();
        }
      } else {
        return await createUser(user);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> appleLogin() async {
    try {
      sa.AuthorizationCredentialAppleID _appleSignIn =
          await sa.SignInWithApple.getAppleIDCredential(scopes: [
        sa.AppleIDAuthorizationScopes.email,
        sa.AppleIDAuthorizationScopes.fullName,
      ]);
      final fauth.AuthCredential credential = fauth.OAuthProvider("apple.com")
          .credential(idToken: _appleSignIn.identityToken);

      await read(firebaseAuthProvider).signInWithCredential(credential);
    } on sa.SignInWithAppleAuthorizationException catch (e) {
      if (e.code != sa.AuthorizationErrorCode.canceled) {
        throw e;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> facebookLogin() async {
    late final LoginResult loginResult;
    late final OAuthCredential facebookAuthCredential;

    loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.cancelled) {
      return;
    }

    // Create a credential from the access token
    facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    await read(firebaseAuthProvider)
        .signInWithCredential(facebookAuthCredential);
  }

  Future<void> handleMutliProviderSignIn(
      SIGNINMETHOD signinmethod, AuthCredential providerOAuthCredential) async {
    await socialLogin(signinmethod);

    await read(firebaseAuthProvider)
        .currentUser!
        .linkWithCredential(providerOAuthCredential);
  }

  @override
  Future<void> twitterLogin() async {
    // Create a TwitterLogin instance

    final twitterLogin = new TwitterLogin(
      apiKey: "VFgiAVqCmf7iBcyvNpJwHeUZi",
      apiSecretKey: "Dw9ueyKvEc6YYdUUSLoBMIwWwwvAEDl0Lyuj4f0qZmdbRtPWYL",
      redirectURI: "social-firebase-auth://",
    );

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();

    if (authResult.status == TwitterLoginStatus.cancelledByUser) {
      return;
    }
    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );

    await read(firebaseAuthProvider)
        .signInWithCredential(twitterAuthCredential);
  }
}
