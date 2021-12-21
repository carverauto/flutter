import 'package:firebase_auth/firebase_auth.dart';
import 'package:chaseapp/helper/helper_functions.dart';
import 'package:chaseapp/models/user.dart';
import 'package:chaseapp/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

abstract class BaseAuth {
 Future<void> sendEmailVerification();
 Future<bool> isEmailVerified();
 Future<User?> getCurrentUser();
 Future<void> signOut();

}

class AuthService implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // create user object based on FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    return (user != null) ? MyUser(uid: user.uid) : null;
  }


  // Future<User> signInWithGoogle(SignInViewModel model) async {
  // Future<String> signInWithGoogle(SignInViewModel model) async {
  signInWithGoogle() async {
    // model.state = ViewState.Busy;

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    // AuthResult authResult = await _auth.signInWithCredential(credential);
    final UserCredential authResult =
    await _auth.signInWithCredential(credential);

    final User? user = authResult.user;

    assert(!user!.isAnonymous);

    // add to the firestore 'users' collection so we can easily generate reports for the CCP overlords
    // await DatabaseService(uid: user.uid).getUserData(user.email).then((value) => DatabaseService(uid: user.uid).updateUserData(user.displayName, user.email, null));
    // await DatabaseService(uid: user.uid).getUserData(user.email).then((value) => DatabaseService(uid: user.uid).updateUserData(user.displayName, user.email, "foobar"));

    assert(await user?.getIdToken() != null);

    assert(!user!.isAnonymous);
    User? currentUser = _auth.currentUser;

    assert(user?.uid == currentUser?.uid);
    assert(user?.email == currentUser?.email);
    assert(user?.photoURL == currentUser?.photoURL);

    // model.state = ViewState.Idle;

    print("Google-User Name: ${user?.displayName}");
    print("Google-User Email ${user?.email}");

    // await DatabaseService(uid: user.uid).updateUserData(fullName, email, password);

    // return _userFromFirebaseUser(currentUser);
    return user;
  }
    // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
        UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
        User? user = result.user;
        return _userFromFirebaseUser(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

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

  // register with email and password
  Future registerWithEmailAndPassword(String fullName, String email, String password) async {
    try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User? user = result.user;
      // Create a new document for the user with uid
      await DatabaseService(uid: user!.uid).updateUserData(fullName, email, password);
      return _userFromFirebaseUser(user);
    } catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  //sign out
  @override
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.saveUserEmailSharedPreference('');
      await HelperFunctions.saveUserNameSharedPreference('');

      return await _auth.signOut().whenComplete(() async {
        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
        });
        await HelperFunctions.getUserEmailSharedPreference().then((value) {
        });
        await HelperFunctions.getUserNameSharedPreference().then((value) {
        });
      });
    } catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}