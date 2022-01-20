import 'dart:async';

import 'package:chaseapp/src/root.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[400],
      statusBarIconBrightness: Brightness.light));
  await Firebase.initializeApp();

  // Setting up const/singletons like this will be redundant after refactoring
  // Prefs.init();

  runApp(ProviderScope(
    child: MyApp(),
  ));
  // First Frame is rendered
  // Initialize Nodle
}
