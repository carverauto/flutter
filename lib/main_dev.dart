import 'package:chaseapp/flavors.dart';
import 'package:chaseapp/main_common.dart';
import 'package:chaseapp/src/root.dart';
import 'package:chaseapp/src/core/top_level_providers/nodle_provider.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() async {
  F.appFlavor = Flavor.DEV;
  await setUpServices();

  // Setting up const/singletons like this will be redundant after refactoring
  // Prefs.init();
  // Initialize other services like SharedPreferances, etc and provide through providers
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferancesProvider.overrideWithValue(prefs),
    ],
    observers: [],
    child: MyApp(),
  ));
}
