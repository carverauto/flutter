import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/src/log_record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// import 'package:device_preview/device_preview.dart';
import 'src/const/colors.dart';
import 'src/modules/chats/view/providers/providers.dart';
import 'src/routes/routes.dart';
import 'src/theme/theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessangerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ChaseApp',
      scaffoldMessengerKey: scaffoldMessangerKey,
      initialRoute: '/',
      builder: (BuildContext context, Widget? child) {
        return StreamChat(
          streamChatThemeData: StreamChatThemeData.dark().copyWith(
            // TODO: Need to debug why?
            // If not added then getStream API is overriding the
            // the user set accentColor in Custom Theme
            colorTheme: StreamColorTheme.dark(
              accentPrimary: primaryColor.shade500,
            ),
          ),
          client: ref.watch(streamChatClientProvider),
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
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  final FirebaseApp firebaseApp = await Firebase.initializeApp();

  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 12),
    ),
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  Logger.root.onRecord.listen((LogRecord record) {
    FirebaseCrashlytics.instance.recordError(
      '${record.loggerName} : ${record.message}',
      record.stackTrace,
      reason: record.error,
      fatal: record.level == Level.SEVERE,
    );
  });

  log(firebaseApp.options.projectId);

  // if (F.appFlavor == Flavor.DEV) {
  // const String instanceId = String.fromEnvironment('Pusher_Instance_Id');
//  await PusherBeams.instance.start(EnvVaribales.instanceId);
  // } else {
  //   const String instanceId = String.fromEnvironment('Prod_Pusher_Instance_Id');

  //   await PusherBeams.instance.start(instanceId);
  // }

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

class ProvidersLogger extends ProviderObserver {
//   @override
//   void didAddProvider(
//     ProviderBase provider,
//     Object? newValue,
//     ProviderContainer container,
//   ) {
//     print(
//       '''
// {
//   "provider": "${provider.name ?? provider.runtimeType}",
//   "newValue": "$newValue"
// }''',
//     );
//   }

//   @override
//   void didUpdateProvider(
//     ProviderBase provider,
//     Object? previousValue,
//     Object? newValue,
//     ProviderContainer container,
//   ) {
//     print(
//       '''
// {
//   "provider": "${provider.name ?? provider.runtimeType}",
//   "newValue": "$newValue"
// }''',
//     );
//   }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    log(
      '''
{
  "provider": "${provider.name ?? provider.runtimeType}"
}''',
    );
  }
}
