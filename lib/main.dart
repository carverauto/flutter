// import 'package:firebase_core/firebase_core.dart'
import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseApp, FirebaseOptions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chaseapp/View_Model/home_view_model.dart';
import 'package:chaseapp/View_Model/sign_in_view_model.dart';
import 'package:chaseapp/utils/locator.dart';
import 'package:chaseapp/utils/prefer.dart';
import 'package:chaseapp/utils/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (!Firebase.apps.length) { }
  print("Firebase.apps.length ${Firebase.apps.length}");

  if (Firebase.apps.length == 0) {
    print("No firebase instance, lets create one..");
    try {
      await Firebase.initializeApp(
          name: 'chaseapp',
          options: FirebaseOptions(
              databaseURL: 'https://chaseapp-8459b.firebaseio.com/',
              apiKey: 'AIzaSyDZVvCuh81AYFsNqNhdI5GUzwQC91na580',
              appId: 'chaseapp-8459b',
              messagingSenderId: '1020122644146',
              projectId: 'chaseapp-8459b'));
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
        builder: (_) => HomeViewModel(),
      ),
    ],
  ));
}

class MyApp extends StatefulWidget {
  Future<FirebaseApp> get _initialization => Firebase.initializeApp();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('initState()');

    //MyApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.grey[400],
//        statusBarColor: Styles.blueColor,
        statusBarIconBrightness: Brightness.light //or set color with: Color(0xFF0000FF)
        ));
    return ChangeNotifierProvider<SignInViewModel>(
      builder: (_) => SignInViewModel(),
      child: Center(
        child: MaterialApp(
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRoute,
          theme: ThemeData(
            primaryColor: Colors.black,
            fontFamily: 'FA',
          ),
        ),
      ),
    );
  }
}
