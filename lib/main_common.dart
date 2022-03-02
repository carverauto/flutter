import 'dart:developer';

import 'package:chaseapp/flavors.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/routes/routes.dart';
import 'package:chaseapp/src/theme/theme.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ChaseApp',
      initialRoute: '/',
      builder: (context, child) {
        return StreamChat(
          streamChatThemeData: StreamChatThemeData.dark().copyWith(
            // TODO: Need to debug why?
            // If not added then getStream API is overriding the
            // the user set accentColor in Custom Theme
            colorTheme: ColorTheme.dark(
              accentPrimary: kPrimaryAccent,
            ),
          ),
          client: ref.read(chatsServiceStateNotifierProvider.notifier).client,
          child: child,
        );
      },
      // locale: Locale('en'), // Add the locale here
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      theme: getThemeData(context),
    );
  }
}

Future<void> setUpServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: Duration(minutes: 1),
    minimumFetchInterval: Duration(hours: 12),
  ));

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  Logger.root.onRecord.listen((record) {
    FirebaseCrashlytics.instance.recordError(
      record.loggerName + " : " + record.message,
      record.stackTrace,
      reason: record.error,
      fatal: record.level == Level.SEVERE,
    );
  });

  log(firebaseApp.options.projectId);

  if (F.appFlavor == Flavor.DEV) {
    const instanceId = String.fromEnvironment("Dev_Pusher_Instance_Id");
    await PusherBeams.instance.start(instanceId);
  } else {
    const instanceId = String.fromEnvironment("Prod_Pusher_Instance_Id");

    await PusherBeams.instance.start(instanceId);
  }

  /*
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  try {
    await pusher.init(
      apiKey: API_KEY,
      cluster: API_CLUSTER,
      onConnectionStateChange: onConnectionStateChange,
      onError: onError,
      onSubscriptionSucceeded: onSubscriptionSucceeded,
      onEvent: onEvent,
      onSubscriptionError: onSubscriptionError,
      onDecryptionFailure: onDecryptionFailure,
      onMemberAdded: onMemberAdded,
      onMemberRemoved: onMemberRemoved,
      // authEndpoint: "<Your Authendpoint>",
      // onAuthorizer: onAuthorizer
    );
    await pusher.subscribe(channelName: 'presence-chatbox');
    await pusher.connect();
  } catch (e) {
    print("ERROR: $e");
  }
   */
}
