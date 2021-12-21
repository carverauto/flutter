import 'dart:async';
import 'package:chaseapp/helper/locator.dart';
import 'package:chaseapp/viewModels/home_view_model.dart';
import 'package:chaseapp/viewModels/sign_in_view_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/helper/helper_functions.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:chaseapp/helper/prefer.dart';
import 'package:chaseapp/helper/routes.dart';
import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.length == 0) {
    print("No firebase instance, lets create one..");
    try {
      await Firebase.initializeApp();
    } catch (err) {
      print('Firebase init error raised ${err.toString()}');
    }
  }

  Prefs.init();
  setLocator();
  runApp(MultiProvider(
    child: MyApp(),
    providers: [
      ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
      ),
    ],
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;
  bool localeLoaded = false;
  bool _isLoggedIn = false;
  bool _initialized = false;
  bool _error = false;

  static const platform = const MethodChannel('com.carverauto.chaseapp/nodle');

  // Define an async function to initialize Nodle SDK
  void initializeNodle() async {
    String value;
    try {
      value = await platform.invokeMethod("init");
    } catch (e) {
      print(e);
    }
    print(value);
    print(this.runtimeType);
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    initializeNodle();
    super.initState();
    _getUserLoggedInStatus();


  }

  _getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp, DeviceOrientation.portraitDown ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.grey[400], statusBarIconBrightness: Brightness.light )); // #TODO: update to support themes

    if (_error) {
      print('Error $_error');
    }

    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(),
      child: Center(
        child: MaterialApp(
          title: 'ChaseApp',
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRoute,
          theme: ThemeData.dark(),
          darkTheme: ThemeData.dark(),
          )
        )
      );
  }
}
