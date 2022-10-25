import 'package:firebase_auth/firebase_auth.dart';

import '../../../../models/user/user_data.dart';
import '../../../../shared/enums/social_logins.dart';

abstract class AuthRepositoryAB {
  Future<void> socialLogin(SIGNINMETHOD loginmethods);
  Future<void> sendSignInLinkToEmail(String email);
  Future<void> signInWithEmailAndLink(String email, String link);
  Future<void> handleMutliProviderSignIn(
    SIGNINMETHOD signinmethod,
    AuthCredential providerOAuthCredential,
  );
  Future<UserData> fetchOrCreateUser(User user);
  Stream<User?> streamLogInStatus();
  Stream<UserData> streamUserData(String? uid);
  Future<void> subscribeToTopics();
  Future<void> saveDeviceTokenToDatabase(User user, String token);
  // Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<User?> getCurrentUser();
  Future<void> signOut();
  void updateTokenWhenRefreshed(User user);
  Future<void> deleteUserAccount(String userId);
}
