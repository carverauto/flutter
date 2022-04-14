import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/user/user_data.dart';
import '../../../../shared/enums/social_logins.dart';
import '../view/providers/providers.dart';
import 'auth_repo_ab.dart';

class AuthRepository implements AuthRepositoryAB {
  AuthRepository({
    required this.read,
  });
  final Reader read;

  @override
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

  // @override
  // Future<void> sendEmailVerification() {
  //   throw UnimplementedError();
  // }

  @override
  Future<void> signOut() {
    return read(authDbProvider).signOut();
  }

  @override
  Stream<UserData> streamUserData(String? uid) {
    return read(authDbProvider).streamUserData(uid);
  }

  @override
  Future<void> subscribeToTopics() {
    return read(authDbProvider).subscribeToTopics();
  }

  @override
  Future<void> saveDeviceTokenToDatabase(User user, String token) {
    return read(authDbProvider).saveDeviceTokenToDatabase(user, token);
  }

  @override
  Future<void> socialLogin(SIGNINMETHOD loginmethods) async {
    return read(authDbProvider).socialLogin(loginmethods);
  }

  @override
  Future<UserData> fetchOrCreateUser(User user) async {
    return await read(authDbProvider).fetchOrCreateUser(user);
  }

  @override
  void updateTokenWhenRefreshed(User user) {
    read(authDbProvider).updateTokenWhenRefreshed(user);
  }

  @override
  Future<void> handleMutliProviderSignIn(
      SIGNINMETHOD signinmethod, AuthCredential providerOAuthCredential) {
    return read(authDbProvider)
        .handleMutliProviderSignIn(signinmethod, providerOAuthCredential);
  }

  @override
  Future<void> sendSignInLinkToEmail(String email) async {
    return read(authDbProvider).sendSignInLinkToEmail(email);
  }

  @override
  Future<void> signInWithEmailAndLink(String email, String link) {
    return read(authDbProvider).signInWithEmailAndLink(email, link);
  }
}
