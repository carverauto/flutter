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
// import 'package:sentry_flutter/sentry_flutter.dart';


// void main() => runApp(MyApp());
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

  //runApp(MyApp());
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
  Locale locale;
  bool localeLoaded = false;
  bool _isLoggedIn = false;
  bool _initialized = false;
  bool _error = false;

  static const nodle = const MethodChannel('io.nodle.sdk.android.Nodle')
  static const Nodle = MethodChannel('io.nodle.sdk.android.Nodle');

  Future<void> _init() async {
    try {
      final result = await Nodle.invokeMethod('init(this)');
    } on PlatformException catch (e) {
      print('Failed to init nodle $e');
    }
  }

  Future<void> _start() async {
    try {
      final result = await Nodle.invokeMethod('start("24696fd1-fe33-4533-8acc-0233eecf07b5")');
    } on PlatformException catch (e) {
      print('Failed to starat nodle $e');
    }
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
    super.initState();
    _init().then((value) => print('Init Nodle'));
    _getUserLoggedInStatus();
    _start().then((value) => print('Startd nodle'));
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
