import 'dart:async';
import 'package:chaseapp/src/root.dart';
import 'package:chaseapp/src/shared/util/helpers/locator.dart';
import 'package:chaseapp/src/modules/home/view/providers/home_view_model.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/prefer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/src/shared/util/helpers/helper_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:chaseapp/helper/prefer.dart';
import 'package:chaseapp/src/routes/routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  try {
    await Firebase.initializeApp();
  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setting up const/singletons like this will be redundant after refactoring
  // Prefs.init();
  runApp(ProviderScope(
    child: MyApp(),
  )
      // MultiProvider(
      //   child: MyApp(),
      //   providers: [
      //     ChangeNotifierProvider<HomeViewModel>(
      //       create: (_) => HomeViewModel(),
      //     ),
      //     ChangeNotifierProvider<SignInViewModel>(
      //       create: (_) => SignInViewModel(),
      //     ),
      //   ],
      // ),
      );
}
