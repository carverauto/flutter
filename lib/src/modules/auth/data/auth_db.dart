import 'dart:async';
import 'dart:developer';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/auth/data/auth_db_ab.dart';
import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as sa;
import 'package:twitter_login/twitter_login.dart';

class AuthDatabase implements AuthDB {
  AuthDatabase({
    required this.read,
  });
  final Reader read;

  @override
  Future<User?> getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    user?.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.emailVerified;
  }

  Future<void> saveFirebaseDeviceToken() async {
    String? token = await read(firebaseMesssagingProvider).getToken();
    if (token != null) {
      saveTokenToDatabase(token);
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await usersCollectionRef.doc(userId).update({
      'tokens': FieldValue.arrayUnion([token]),
      'lastTokenUpdate': DateTime.now()
    });
  }

  void updateTokenWhenRefreshed() {
    read(firebaseMesssagingProvider).onTokenRefresh.listen(saveTokenToDatabase);
  }

  // Subcribe to topics
  Future<void> subscribeToTopics() async {
    await read(firebaseMesssagingProvider).subscribeToTopic("chases");
  }

  //sign out
  @override
  Future<void> signOut() async {
    try {
      // await HelperFunctions.saveUserLoggedInSharedPreference(false);
      // await HelperFunctions.saveUserEmailSharedPreference('');
      // await HelperFunctions.saveUserNameSharedPreference('');
      await read(googleSignInProvider).signOut();
      await read(firebaseAuthProvider).signOut();
      await read(facebookSignInProvider).logOut();
      // return await read(firebaseAuthProvider).signOut().whenComplete(() async {
      //   await HelperFunctions.getUserLoggedInSharedPreference()
      //       .then((value) {});
      //   await HelperFunctions.getUserEmailSharedPreference().then((value) {});
      //   await HelperFunctions.getUserNameSharedPreference().then((value) {});
      // });
    } catch (e) {
      log(e.toString());
    }
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
  Future<UserCredential> googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser == null) {
      throw Exception('Google sign in failed');
    }

    GoogleSignInAuthentication? _googleAuth = await _googleUser.authentication;
    final fauth.AuthCredential credential = fauth.GoogleAuthProvider.credential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

    return await read(firebaseAuthProvider).signInWithCredential(credential);
  }

  @override
  Future<void> socialLogin(SIGNINMETHOD loginmethods) async {
    try {
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
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          rethrow;
        default:
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserData> createUser(User user) async {
    final DocumentReference<UserData> docRef = usersCollectionRef.doc(user.uid);
    try {
      await docRef.set(
        UserData(
          uid: user.uid,
          userName: user.displayName!,
          email: user.email!,
          photoURL: null,
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
        sa.AppleIDAuthorizationScopes.fullName
      ]);

      if (_appleSignIn.identityToken == null) {
        return;
      }
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
        redirectURI: "social-firebase-auth://");

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();

    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );

    await read(firebaseAuthProvider)
        .signInWithCredential(twitterAuthCredential);
  }
}
