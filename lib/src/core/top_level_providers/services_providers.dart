import 'package:chaseapp/src/core/modules/chase/data/chase_db.dart';
import 'package:chaseapp/src/core/modules/chase/data/chase_db_ab.dart';
import 'package:chaseapp/src/core/modules/chase/domain/chase_repo.dart';
import 'package:chaseapp/src/core/modules/chase/domain/chase_repo_ab.dart';
import 'package:chaseapp/src/core/notifiers/app_update_notifier.dart';
import 'package:chaseapp/src/models/app_update_info/app_update_info.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferancesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final chaseDbProvider = Provider<ChaseDbAB>((ref) => ChaseDatabase());

final chaseRepoProvider =
    Provider<ChaseRepoAB>((ref) => ChaseRepository(read: ref.read));

final streamChaseProvider = StreamProvider.family<Chase, String>(
    (ref, chaseId) => ref.watch(chaseRepoProvider).streamChase(chaseId));

final isConnected = StreamProvider<bool>((ref) async* {
  ConnectivityResult result = await Connectivity().checkConnectivity();
  bool active = result != ConnectivityResult.none;

  yield active;

  yield* Connectivity().onConnectivityChanged.map((event) {
    bool active =
        ConnectivityResult.values[event.index] != ConnectivityResult.none;

    return active;
  });
});

final appInfoProvider =
    Provider<PackageInfo>((ref) => throw UnimplementedError());

final checkForUpdateStateNotifier =
    StateNotifierProvider<AppUpdateStateNotifier, AsyncValue<AppUpdateInfo>>(
        (ref) {
  return AppUpdateStateNotifier(read: ref.read);
});
