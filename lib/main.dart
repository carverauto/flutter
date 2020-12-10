import 'package:flutter/material.dart';
import 'package:chaseapp/helper/helper_functions.dart';
import 'package:chaseapp/pages/authenticate_page.dart';
import 'package:chaseapp/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseApp, FirebaseOptions;
import 'dart:async';
import 'dart:io' show Platform;

// void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  Future<FirebaseApp> get _initialization => Firebase.initializeApp();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedIn = false;

  @override
  void initState() {
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
    return MaterialApp(
      title: 'ChaseApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : AuthenticatePage() : Center(child: CircularProgressIndicator()),
      home: _isLoggedIn ? HomePage() : AuthenticatePage(),
      //home: HomePage(),
    );
  }
}
