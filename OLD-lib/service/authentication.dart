import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    return FirebaseAuth.instance.currentUser.uid;
  }

  Future<String> signUp(String email, String password) async {
    return FirebaseAuth.instance.currentUser.uid;
  }

  Future<User> getCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser;
    return user.emailVerified;
  }
}
