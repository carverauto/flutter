import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/user/user_data.dart';
import '../../../../shared/enums/social_logins.dart';
import '../view/providers/providers.dart';
import 'auth_repo_ab.dart';

class AuthRepository implements AuthRepositoryAB {
  AuthRepository({
    required this.ref,
  });
  final Ref ref;

  @override
  Stream<User?> streamLogInStatus() {
    return ref.read(authDbProvider).streamLogInStatus();
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
    return ref.read(authDbProvider).signOut();
  }

  @override
  Stream<UserData> streamUserData(String? uid) {
    return ref.read(authDbProvider).streamUserData(uid);
  }

  @override
  Future<void> subscribeToTopics() {
    return ref.read(authDbProvider).subscribeToTopics();
  }

  @override
  Future<void> saveDeviceTokenToDatabase(User user, String token) {
    return ref.read(authDbProvider).saveDeviceTokenToDatabase(user, token);
  }

  @override
  Future<void> socialLogin(SIGNINMETHOD loginmethods) async {
    return ref.read(authDbProvider).socialLogin(loginmethods);
  }

  @override
  Future<UserData> fetchOrCreateUser(User user) async {
    return await ref.read(authDbProvider).fetchOrCreateUser(user);
  }

  @override
  void updateTokenWhenRefreshed(User user) {
    ref.read(authDbProvider).updateTokenWhenRefreshed(user);
  }

  @override
  Future<void> handleMutliProviderSignIn(
    SIGNINMETHOD signinmethod,
    AuthCredential providerOAuthCredential,
  ) {
    return ref
        .read(authDbProvider)
        .handleMutliProviderSignIn(signinmethod, providerOAuthCredential);
  }

  @override
  Future<void> sendSignInLinkToEmail(String email) async {
    return ref.read(authDbProvider).sendSignInLinkToEmail(email);
  }

  @override
  Future<void> signInWithEmailAndLink(String email, String link) {
    return ref.read(authDbProvider).signInWithEmailAndLink(email, link);
  }

  @override
  Future<void> deleteUserAccount(String userId) {
    return ref.read(authDbProvider).deleteUserAccount(userId);
  }
}
