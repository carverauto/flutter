// ignore_for_file: non_constant_identifier_names, avoid_positional_boolean_parameters

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../models/app_update_info/app_update_info.dart';
import '../../shared/widgets/dialogs/app_update_dialog.dart';
import '../top_level_providers/firebase_providers.dart';
import '../top_level_providers/services_providers.dart';

//a state notifier that can be used to call a future after an event.
//it will automatically update the state when the future completes
//call [doRequest] to call the future
//pass in [request] to the [doRequest] function or in the constructor
//the [request] in the doRequest function will take precendence over the [request] in the constructor
class AppUpdateStateNotifier extends StateNotifier<AsyncValue<AppUpdateInfo>> {
  AppUpdateStateNotifier({
    required this.ref,
  }) : super(const AsyncValue.loading());

  final Ref ref;

  late AppUpdateInfo _appUpdateInfo;

  bool isInfoInitialized = false;
  final Logger logger = Logger('AppUpdateStateNotifier');

  Future<void> showOrNotShowUpdateDialog(BuildContext context) async {
    if (_appUpdateInfo.shouldUpdate) {
      await showUpdateDialog(context, _appUpdateInfo);
    }
  }

  // ignore: public_member_api_docs
  // ignore: long-method
  Future<void> checkForUpdate([bool force_fetch = false]) async {
    //save a flag in sharedpreferances
    // depending on the flag make the decision of whether to make
    // the call on app startup or not
    // A bg notification from firebase would set flag to true if there's any update available
    if (!isInfoInitialized || force_fetch) {
      try {
        //set loading state
        state = const AsyncValue.loading();

        //get should fetch data bool from shared preferances

        final bool shouldFetch =
            ref.read(sharedPreferancesProvider).getBool('should_fetch') ??
                false;
        final FirebaseRemoteConfig remoteConfig =
            ref.read(firebaseRemoteConfigProvider);

        late final bool updated;
        if (shouldFetch || force_fetch) {
          await remoteConfig.setConfigSettings(
            RemoteConfigSettings(
              fetchTimeout: const Duration(seconds: 10),
              minimumFetchInterval: const Duration(),
            ),
          );
          updated = await remoteConfig.fetchAndActivate();
        } else {
          //TODO: if used fetchAndActive(), it always returns true
          //else false
          //Need To Report
          await remoteConfig.fetch();
          updated = await remoteConfig.activate();
        }

        final PackageInfo packageInfo = ref.read(appInfoProvider);

        final String current_app_version = packageInfo.version;

        //app latest version
        final Map<String, dynamic> store_url =
            jsonDecode(remoteConfig.getString('store_url'))
                as Map<String, dynamic>;
        final Map<String, dynamic> latest_app_version_map =
            jsonDecode(remoteConfig.getString('latest_app_version'))
                as Map<String, dynamic>;
        final String androidVersionString =
            latest_app_version_map['android'] as String;
        final int androidVersion =
            int.parse(androidVersionString.split('.').join());
        final String iosVersionString = latest_app_version_map['ios'] as String;
        final int iosVersion = int.parse(iosVersionString.split('.').join());
        final LatestAppVersion latest_app_version = LatestAppVersion(
          android: androidVersion,
          ios: iosVersion,
        );
        final bool force_update = remoteConfig.getBool('force_update');

        log('current_app_version: $current_app_version');
        log('latest_app_version: $latest_app_version_map');
        log('force_update: $force_update');
        log('store_url: $store_url');

        if (updated) {
          log('Remote Config updated');
        } else {
          log('Remote Config prev updated');
        }
        final int currentVersion =
            int.parse(current_app_version.split('.').join());
        _appUpdateInfo = AppUpdateInfo(
          current_app_version: currentVersion,
          app_store: store_url['app_store'] as String,
          force_update: force_update,
          latest_app_version: latest_app_version,
          play_store: store_url['play_store'] as String,
        );

        isInfoInitialized = true;

        await ref
            .read(sharedPreferancesProvider)
            .setBool('should_fetch', false);

        state = AsyncValue.data(_appUpdateInfo);
      } catch (e, stk) {
        logger.warning(
          'Something went wrong while checking if app requires an update.',
          e,
          stk,
        );
        state = AsyncValue.error(e, stk);
      }
    } else {
      // state = AsyncValue.data(_appUpdateInfo);
    }
  }
}
