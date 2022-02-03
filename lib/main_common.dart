import 'dart:developer';

import 'package:chaseapp/src/core/top_level_providers/nodle_provider.dart';
import 'package:chaseapp/src/routes/routes.dart';
import 'package:chaseapp/src/theme/theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(nodleProvider.notifier).initializeNodle();
    return MaterialApp(
      title: 'ChaseApp',
      initialRoute: '/',
      locale: Locale('en'), // Add the locale here
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      theme: getThemeData(context),
    );
  }
}

Future<void> setUpServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Logger.root.onRecord.listen((record) {
    FirebaseCrashlytics.instance.recordError(
      record.loggerName + " : " + record.message,
      record.stackTrace,
      reason: record.error,
      fatal: record.level == Level.SEVERE,
    );
  });

  log(firebaseApp.options.projectId);
}
