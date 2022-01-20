import 'package:chaseapp/src/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;
  bool localeLoaded = false;

  static const platform = MethodChannel('com.carverauto.chaseapp/nodle');

  // Define an async function to initialize Nodle SDK
  void initializeNodle() async {
    String value;
    try {
      value = await platform.invokeMethod("init");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    initializeNodle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: update to support themes

    return MaterialApp(
      title: 'ChaseApp',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
