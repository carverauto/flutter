import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepositoryAB {
  Future<void> socialLogin(SIGNINMETHOD loginmethods);
  Future<void> handleMutliProviderSignIn(
      SIGNINMETHOD signinmethod, AuthCredential providerOAuthCredential);
  Future<UserData> fetchOrCreateUser(User user);
  Stream<User?> streamLogInStatus();
  Stream<UserData> streamUserData(String uid);
  Future<void> subscribeToTopics();
  Future<void> saveDeviceTokenToDatabase(User user, String token);
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<User?> getCurrentUser();
  Future<void> signOut();
  void updateTokenWhenRefreshed(User user);
  Future<String> fetchUserStreamToken(String userId);
}
