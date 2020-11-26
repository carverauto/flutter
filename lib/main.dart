import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseApp;
import 'package:chaseapp/login_page.dart';

// void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<FirebaseApp> get _initialization => Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChaseApp Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
