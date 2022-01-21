import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDB {
  Stream<UserData> streamUserData();
  Stream<User?> streamLogInStatus();
  Future<void> socialLogin(SIGNINMETHOD loginmethods);
  Future<void> subscribeToTopics();
  Future<void> saveFirebaseDeviceToken();
  Future<void> createUserDoc();
  Future<void> sendEmailVerification();
  Future<void> googleLogin();
  Future<bool> isEmailVerified();
  Future<User?> getCurrentUser();
  Future<void> signOut();
  void updateTokenWhenRefreshed();
}
