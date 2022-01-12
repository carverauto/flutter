import 'dart:async';
import 'package:chaseapp/helper/locator.dart';
import 'package:chaseapp/viewModels/home_view_model.dart';
import 'package:chaseapp/viewModels/sign_in_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/helper/helper_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:chaseapp/helper/prefer.dart';
import 'package:chaseapp/helper/routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
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

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Prefs.init();
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

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static const platform = MethodChannel('com.carverauto.chaseapp/nodle');

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'live', // id
    'WE HAVE A CHASE!', // title
    importance: Importance.max,
  );

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

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Handle high priority foreground notifications
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    print(message.data);
    Fluttertoast.showToast(
        msg: message.data.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    /*
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(context, '/chat',
        arguments: ChatArguments(message),
      );
    }
     */
  }

  @override
  void initState() {
    initializeFlutterFire();
    initializeNodle();
    super.initState();
    _getUserLoggedInStatus();
    _startFirebaseMessaging();
    setupInteractedMessage();
  }

  _startFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
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
      if (kDebugMode) {
        print('Error $_error');
      }
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
