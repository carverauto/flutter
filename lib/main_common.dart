import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

Future<void> setUpServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[400],
      statusBarIconBrightness: Brightness.light));
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
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
