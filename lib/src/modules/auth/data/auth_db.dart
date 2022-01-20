import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/auth/data/auth_db_ab.dart';
import 'package:chaseapp/src/services/database_service.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';
import 'package:chaseapp/src/shared/util/helpers/helper_functions.dart';
import 'package:chaseapp/src/top_level_providers/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:http/http.dart';

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

    updateTokenWhenRefreshed();
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
  Stream<UserData> streamUserData() {
    final uid = read(firebaseAuthProvider).currentUser?.uid;
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

    try {
      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

      if (_googleUser == null) {
        return;
      }

      GoogleSignInAuthentication? _googleAuth =
          await _googleUser.authentication;
      final fauth.AuthCredential credential =
          fauth.GoogleAuthProvider.credential(
              idToken: _googleAuth.idToken,
              accessToken: _googleAuth.accessToken);

      await read(firebaseAuthProvider).signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw UnimplementedError();
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createUserDoc() async {
    final user = read(firebaseAuthProvider).currentUser!;
    final uid = user.uid;

    final DocumentReference docRef = usersCollectionRef.doc(uid);

    final userDoc = await docRef.get();

    if (!userDoc.exists) {
      await usersCollectionRef.doc(uid).set(
            UserData(
                uid: uid,
                userName: user.displayName!,
                email: user.email!,
                photoURL: null,
                lastUpdated: DateTime.now().millisecondsSinceEpoch),
          );
    }
  }

  @override
  Future<void> socialLogin(SIGNINMETHOD loginmethods) async {
    switch (loginmethods) {
      case SIGNINMETHOD.GOOGLE:
        await googleLogin();
        break;

      case SIGNINMETHOD.APPLE:
        throw UnimplementedError();
        break;
      default:
    }
  }
}
