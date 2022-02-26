import 'package:chaseapp/src/core/modules/auth/data/auth_db.dart';
import 'package:chaseapp/src/core/modules/auth/data/auth_db_ab.dart';
import 'package:chaseapp/src/core/modules/auth/domain/auth_repo.dart';
import 'package:chaseapp/src/core/modules/auth/domain/auth_repo_ab.dart';
import 'package:chaseapp/src/core/notifiers/post_login_state_notifier.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
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

final fetchUserProvider = FutureProvider.family<UserData, User>(
    (ref, user) async => ref.read(authRepoProvider).fetchOrCreateUser(user));

final userStreamProvider = StreamProvider.autoDispose<UserData>((ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser!;
  return ref.read(authRepoProvider).streamUserData(user.uid);
});
