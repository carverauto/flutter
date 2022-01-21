import 'package:chaseapp/src/modules/auth/data/auth_db.dart';
import 'package:chaseapp/src/modules/auth/data/auth_db_ab.dart';
import 'package:chaseapp/src/modules/auth/domain/auth_repo.dart';
import 'package:chaseapp/src/modules/auth/domain/auth_repo_ab.dart';
import 'package:chaseapp/src/modules/auth/view/notifiers/post_login_state_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postLoginStateNotifierProvider =
    StateNotifierProvider<PostLoginStateNotifier, AsyncValue<void>>((ref) {
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

final createUserProvider = FutureProvider<void>(
    (ref) async => ref.read(authRepoProvider).createUser());

// final userstreamprovider = StreamProvider<UserData>((ref) async* {
//   final authrepo = ref.watch(authRepoProvider);

//   yield* ref.watch(streamLogInStatus).maybeWhen(
//         data: (user) async* {
//           //get user data
//           yield* authrepo.streamUserData();
//         },
//         orElse: () async* {},
//         error: (error, s) async* {
//           throw error;
//         },
//       );
// });
