import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/user/user_data.dart';
import '../../../../notifiers/post_login_state_notifier.dart';
import '../../../../top_level_providers/firebase_providers.dart';
import '../../data/auth_db.dart';
import '../../data/auth_db_ab.dart';
import '../../domain/auth_repo.dart';
import '../../domain/auth_repo_ab.dart';

final AutoDisposeStateNotifierProvider<PostLoginStateNotifier, AsyncValue<void>>
    postLoginStateNotifierProvider =
    StateNotifierProvider.autoDispose<PostLoginStateNotifier, AsyncValue<void>>(
  (
    AutoDisposeStateNotifierProviderRef<PostLoginStateNotifier,
            AsyncValue<void>>
        ref,
  ) {
    return PostLoginStateNotifier(ref);
  },
);

final Provider<AuthRepositoryAB> authRepoProvider = Provider<AuthRepositoryAB>(
  (ProviderRef<AuthRepositoryAB> ref) => AuthRepository(
    ref: ref,
  ),
);
final Provider<AuthDB> authDbProvider = Provider<AuthDB>(
  (ProviderRef<AuthDB> ref) {
    return AuthDatabase(
      firebaseAuth: ref.read(firebaseAuthProvider),
      firebaseMessaging: ref.read(firebaseMessagingProvider),
      googleSignIn: ref.read(googleSignInProvider),
      facebookAuth: ref.read(facebookSignInProvider),
    );
  },
);

final StreamProvider<User?> streamLogInStatus =
    StreamProvider<User?>((StreamProviderRef<User?> ref) {
  final AuthRepositoryAB authrepo = ref.watch(authRepoProvider);

  return authrepo.streamLogInStatus();
});

final AutoDisposeFutureProviderFamily<UserData, User> fetchUserProvider =
    FutureProvider.autoDispose.family<UserData, User>(
  (AutoDisposeFutureProviderRef<UserData> ref, User user) async =>
      ref.read(authRepoProvider).fetchOrCreateUser(user),
);

final StreamProvider<UserData> userStreamProvider = StreamProvider<UserData>(
  (
    StreamProviderRef<UserData> ref,
  ) {
    final String? uid = ref.watch(streamLogInStatus).value?.uid;

    return ref.read(authRepoProvider).streamUserData(uid);
  },
);
