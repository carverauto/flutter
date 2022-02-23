import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_page.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handlebgmessage(RemoteMessage message) async {
  log("Background message arrived--->" + message.data.toString());

  switch (message.data["type"]) {
    //TODO: Add cases for notification types
    case 'chat':
      break;
    case 'update':
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool should_fetch = message.data["config_state"] == "stale";
      await prefs.setBool("should_fetch", should_fetch);
      break;

    default:
  }

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

class HomeWrapper extends ConsumerStatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends ConsumerState<HomeWrapper>
    with WidgetsBindingObserver {
  final Logger logger = Logger("HomeWrapper");
  Timer? _timerLink;

  Future<void> navigateToView(Uri deepLink) async {
    final chaseId = deepLink.queryParameters["chaseId"];

    Navigator.pushNamed(context, RouteName.CHASE_VIEW, arguments: {
      "chaseId": chaseId,
    });
  }

  void handledynamiclink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      await navigateToView(deepLink);
    }
  }

  void handlenotifications(RemoteMessage message) async {
    log("Notification Message Arrived--->" + message.data.toString());

    switch (message.data["type"]) {
      //TODO: Add cases for notification types
      case 'chat':
        break;
      case 'update':
        handlebgmessage(message).then(
          (value) => ref
              .read(checkForUpdateStateNotifier.notifier)
              .checkForUpdate(true),
        );

        break;
      case 'chase':
        final chasesPaginationProvider = chasesPaginatedStreamProvider(logger);

        //Fetch new chases when user opens chase notification
        // Top chases are streamed from the database so they'll get updated
        // if any updates happen in the chases
        // TODO: Can we do better?
        ref.read(chasesPaginationProvider.notifier).fetchFirstPage(true);
        // TODO:Navigate to chase view
        final String? chaseId = message.data["chaseId"] as String?;

        if (chaseId != null) {
          Navigator.pushNamed(context, RouteName.CHASE_VIEW, arguments: {
            "chaseId": chaseId,
          });
        } else {
          log("Chase id Not Found!");
        }
        // throw UnimplementedError();
        break;
      default:
    }
  }

  Future<void> handleMessagesFromTerminatedState() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      handlenotifications(message);
    }
  }

  Future<void> handlemessagesthatopenedtheappFromBackgroundState() async {
    // final message = await FirebaseMessaging.instance.getInitialMessage();

    // if (message != null) {
    //   handlenotifications(message);
    // }

    // FirebaseMessaging.onBackgroundMessage(handlebgmessage);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data.isNotEmpty) {
        handlenotifications(event);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    // Dynamic Link Receiver Configurations
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      log("Dynamic Link Recieved--->" + dynamicLink.link.toString());
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        await navigateToView(deepLink);
      }
    }, onError: (Object error, StackTrace stackTrace) {
      log("Error while recieving dynamic link", error: error);
    });

    PusherBeams.instance.onMessageReceivedInTheForeground((notification) {
      log("Message Recieved in the foreground--->" + notification.toString());
    });

    handledynamiclink();

    // Notifications Receiver Configurations
    FirebaseMessaging.onBackgroundMessage(handlebgmessage);

    handleMessagesFromTerminatedState();
    handlemessagesthatopenedtheappFromBackgroundState();
    // If we are managing all notifications with PusherBeams listener,
    // then this listener here will be redundant.
    // FirebaseMessaging.onMessage.listen((event) {
    //   if (event.data.isNotEmpty) {
    //     handlenotifications(event);
    //   }
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        _timerLink = new Timer(
          const Duration(milliseconds: 1000),
          () {
            // handledynamiclink(ref, context);
            handlemessagesthatopenedtheappFromBackgroundState();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
