import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:pusher_beams/pusher_beams.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../models/app_update_info/app_update_info.dart';
import '../../shared/util/firebase_collections.dart';
import '../modules/chase/data/chase_db.dart';
import '../modules/chase/data/chase_db_ab.dart';
import '../modules/chase/domain/chase_repo.dart';
import '../modules/chase/domain/chase_repo_ab.dart';
import '../notifiers/app_update_notifier.dart';
import '../notifiers/in_app_purchases_state_notifier.dart';

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
  (ProviderRef<ChaseRepoAB> ref) => ChaseRepository(ref: ref),
);

final StreamProvider<bool> isConnectedStreamProvider =
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
  (
    StateNotifierProviderRef<AppUpdateStateNotifier, AsyncValue<AppUpdateInfo>>
        ref,
  ) {
    return AppUpdateStateNotifier(
      ref: ref,
    );
  },
);

final Provider<PusherBeams> pusherBeamsProvider = Provider<PusherBeams>(
  (ProviderRef<PusherBeams> ref) => PusherBeams.instance,
);

final Provider<GlobalKey> appGlobalKeyProvider =
    Provider<GlobalKey>((ProviderRef<GlobalKey> ref) {
  return GlobalKey();
});

final StateNotifierProvider<InAppPurchasesStateNotifier,
        AsyncValue<purchases.CustomerInfo>> inAppPurchasesStateNotifier =
    StateNotifierProvider<InAppPurchasesStateNotifier,
        AsyncValue<purchases.CustomerInfo>>(
  (
    StateNotifierProviderRef<InAppPurchasesStateNotifier,
            AsyncValue<purchases.CustomerInfo>>
        ref,
  ) {
    return InAppPurchasesStateNotifier(
      ref,
    );
  },
);
