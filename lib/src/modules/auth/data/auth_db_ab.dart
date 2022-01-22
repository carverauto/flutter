import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDB {
  Future<UserData> fetchOrCreateUser();
  Future<void> createUser();
  Future<UserData> fetchUser();
  Stream<UserData> streamUserData();
  Stream<User?> streamLogInStatus();
  Future<void> socialLogin(SIGNINMETHOD loginmethods);
  Future<void> subscribeToTopics();
  Future<void> saveFirebaseDeviceToken();
  Future<void> sendEmailVerification();
  Future<UserCredential> googleLogin();
  Future<void> appleLogin();
  Future<void> facebookLogin();
  Future<void> twitterLogin();
  Future<bool> isEmailVerified();
  Future<User?> getCurrentUser();
  Future<void> signOut();
  void updateTokenWhenRefreshed();
}
