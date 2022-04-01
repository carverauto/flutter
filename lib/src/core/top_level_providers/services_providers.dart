import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../models/app_update_info/app_update_info.dart';
import '../../models/chase/chase.dart';
import '../../modules/chase_view/view/providers/providers.dart';
import '../../shared/util/firebase_collections.dart';
import '../modules/chase/data/chase_db.dart';
import '../modules/chase/data/chase_db_ab.dart';
import '../modules/chase/domain/chase_repo.dart';
import '../modules/chase/domain/chase_repo_ab.dart';
import '../notifiers/app_update_notifier.dart';

final Provider<SharedPreferences> sharedPreferancesProvider =
    Provider<SharedPreferences>((ProviderRef<SharedPreferences> ref) {
  throw UnimplementedError();
});

final Provider<ChaseDbAB> chaseDbProvider = Provider<ChaseDbAB>(
  (ProviderRef<ChaseDbAB> ref) => ChaseDatabase(
    chasesCollectionRef,
  ),
);

final Provider<ChaseRepoAB> chaseRepoProvider = Provider<ChaseRepoAB>(
  (ProviderRef<ChaseRepoAB> ref) => ChaseRepository(read: ref.read),
);

final AutoDisposeStreamProviderFamily<Chase, String> streamChaseProvider =
    StreamProvider.autoDispose.family<Chase, String>(
  (AutoDisposeStreamProviderRef<Chase> ref, String chaseId) {
    ref.onDispose(() {
      // ref
      //     .read(chaseEventsNotifierProvider(chaseId).notifier)
      //     .streamController
      //     .close();
      ref.read(popupsEvetnsStreamControllerProvider).close();
      ref.read(theaterEvetnsStreamControllerProvider).close();
      ref.read(chaseEventsNotifierProvider(chaseId).notifier).dispose();
    });

    return ref.watch(chaseRepoProvider).streamChase(chaseId);
  },
);

final StreamProvider<bool> isConnected =
    StreamProvider<bool>((StreamProviderRef<bool> ref) async* {
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  final bool active = result != ConnectivityResult.none;

  yield active;

  yield* Connectivity().onConnectivityChanged.map((ConnectivityResult event) {
    final bool active =
        ConnectivityResult.values[event.index] != ConnectivityResult.none;

    return active;
  });
});

final Provider<PackageInfo> appInfoProvider = Provider<PackageInfo>(
  (ProviderRef<PackageInfo> ref) => throw UnimplementedError(),
);

final StateNotifierProvider<AppUpdateStateNotifier, AsyncValue<AppUpdateInfo>>
    checkForUpdateStateNotifier =
    StateNotifierProvider<AppUpdateStateNotifier, AsyncValue<AppUpdateInfo>>(
  (StateNotifierProviderRef<AppUpdateStateNotifier, AsyncValue<AppUpdateInfo>>
      ref) {
    return AppUpdateStateNotifier(
      read: ref.read,
    );
  },
);

final Provider<PusherBeams> pusherBeamsProvider = Provider<PusherBeams>(
  (ProviderRef<PusherBeams> ref) => PusherBeams.instance,
);
