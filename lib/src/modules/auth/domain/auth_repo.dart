import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/auth/domain/auth_repo_ab.dart';
import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class AuthRepository implements AuthRepositoryAB {
  AuthRepository({
    required this.read,
  });
  final Reader read;

  Stream<User?> streamLogInStatus() {
    return read(authDbProvider).streamLogInStatus();
  }

  @override
  Future<User?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailVerified() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    return read(authDbProvider).signOut();
  }

  @override
  Stream<UserData> streamUserData(String uid) {
    return read(authDbProvider).streamUserData(uid);
  }

  @override
  Future<void> subscribeToTopics() {
    return read(authDbProvider).subscribeToTopics();
  }

  @override
  Future<void> saveFirebaseDeviceToken() {
    return read(authDbProvider).saveFirebaseDeviceToken();
  }

  @override
  Future<void> socialLogin(SIGNINMETHOD loginmethods) async {
    return read(authDbProvider).socialLogin(loginmethods);
  }

  @override
  Future<UserData> fetchOrCreateUser(User user) async {
    // TODO: implement createUser
    return await read(authDbProvider).fetchOrCreateUser(user);
  }

  @override
  void updateTokenWhenRefreshed() {
    read(authDbProvider).updateTokenWhenRefreshed();
  }

  @override
  Future<void> handleMutliProviderSignIn(
      SIGNINMETHOD signinmethod, AuthCredential providerOAuthCredential) {
    return read(authDbProvider)
        .handleMutliProviderSignIn(signinmethod, providerOAuthCredential);
  }
}
