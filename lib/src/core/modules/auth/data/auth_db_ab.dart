import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDB {
  Future<UserData> fetchOrCreateUser(User user);
  Future<void> createUser(User user);
  Future<UserData> fetchUser(User user);
  Stream<UserData> streamUserData(String uid);
  Stream<User?> streamLogInStatus();
  Future<void> socialLogin(SIGNINMETHOD loginmethods);
  Future<void> handleMutliProviderSignIn(
      SIGNINMETHOD signinmethod, AuthCredential providerOAuthCredential);
  Future<void> subscribeToTopics();
  Future<void> saveDeviceTokenToDatabase(User user, String token);
  Future<void> googleLogin();
  Future<void> appleLogin();
  Future<void> facebookLogin();
  Future<void> twitterLogin();
  Future<void> sendSignInLinkToEmail(String email);
  Future<void> signInWithEmailAndLink(String email, String link);
  Future<void> signOut();
  void updateTokenWhenRefreshed(User user);
}
