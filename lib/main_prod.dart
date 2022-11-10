import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flavors.dart';
import 'main_common.dart';
import 'src/core/top_level_providers/services_providers.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      F.appFlavor = Flavor.PROD;
      await setUpServices();

      final PackageInfo info = await PackageInfo.fromPlatform();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      runApp(
        ProviderScope(
          overrides: [
            appInfoProvider.overrideWithValue(info),
            sharedPreferancesProvider.overrideWithValue(prefs),
          ],
          observers: [ProvidersLogger()],
          child: const MyApp(),
        ),
      );
    },
    (Object error, StackTrace stack) async {
      return FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}
