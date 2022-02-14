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
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

final apiKey = "2cfcx4vhp35x";
// final userToken =
//     "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY2FsbS1maXJlZmx5LTIifQ.h8ZIumjFHC1CriGu4aLY8wQPUmTrf-NSWd3SxAiF39I";

/// Create a new instance of [StreamChatClient] passing the apikey obtained from
/// your project dashboard.
final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
);

/// Set the current user and connect the websocket.
/// In a production scenario, this should be done using a backend to generate
/// a user token using our server SDK.
/// Please see the following for more information:
/// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
