import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepositoryAB {
  Future<void> socialLogin(SIGNINMETHOD loginmethods);
  Future<void> createUser();
  Stream<User?> streamLogInStatus();
  Stream<UserData> streamUserData();
  Future<void> subscribeToTopics();
  Future<void> saveFirebaseDeviceToken();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<User?> getCurrentUser();
  Future<void> signOut();
}
