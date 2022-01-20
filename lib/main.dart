import 'package:chaseapp/src/root.dart';
import 'package:chaseapp/src/top_level_providers/nodle_provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // Initialize other services like SharedPreferances, etc and provide through providers
  runApp(ProviderScope(
    child: MyApp(),
  ));
}
