import 'dart:developer';

import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/auth/data/auth_db.dart';
import 'package:chaseapp/src/modules/auth/data/auth_db_ab.dart';
import 'package:chaseapp/src/modules/auth/domain/auth_repo.dart';
import 'package:chaseapp/src/modules/auth/domain/auth_repo_ab.dart';
import 'package:chaseapp/src/modules/auth/view/notifiers/post_login_state_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postLoginStateNotifierProvider =
    StateNotifierProvider.autoDispose<PostLoginStateNotifier, AsyncValue<void>>(
        (ref) {
  return PostLoginStateNotifier(ref.read);
});

final authRepoProvider = Provider<AuthRepositoryAB>((ref) => AuthRepository(
      read: ref.read,
    ));
final authDbProvider = Provider<AuthDB>((ref) => AuthDatabase(
      read: ref.read,
    ));

final streamLogInStatus = StreamProvider<User?>((ref) {
  final authrepo = ref.watch(authRepoProvider);
  return authrepo.streamLogInStatus();
});

final getUserProvider = FutureProvider<UserData>(
    (ref) async => ref.read(authRepoProvider).fetchOrCreateUser());

final streamUserProvider = StreamProvider<UserData>(
    (ref) => ref.read(authRepoProvider).streamUserData());
