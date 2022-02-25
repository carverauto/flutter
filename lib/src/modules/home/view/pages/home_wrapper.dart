import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_page.dart';
import 'package:chaseapp/src/modules/home/view/parts/helpers.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_handler.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pusher_beams/pusher_beams.dart';

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

  void handleDynamicLinkFromTerminatedState() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      await navigateToView(deepLink);
    }
  }

  void handlenotifications(RemoteMessage message) async {
    log("Notification Message Arrived--->" + message.data.toString());

    final data = message.data;

    if (data["interest"] != null) {
      final notificationData = getNotificationDataFromMessage(message);

      notificationHandler(context, notificationData, read: ref.read);
    } else {
      logger.warning("Notification data didn't contained interest field");
    }
  }

  Future<void> handleMessagesFromTerminatedState() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      handlenotifications(message);
    }
  }

  Future<void> handlemessagesthatopenedtheappFromBackgroundState() async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data.isNotEmpty) {
        handlenotifications(event);
      }
    });
  }

  void handleDynamicLinkOpenedFromBackgroundState() {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      log("Dynamic Link Recieved--->" + dynamicLink.link.toString());
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        await navigateToView(deepLink);
      }
    }, onError: (Object error, StackTrace stackTrace) {
      log("Error while recieving dynamic link", error: error);
    });
  }

  void handleNotificationInForegroundState() {
    PusherBeams.instance.onMessageReceivedInTheForeground((notification) {
      log("Pusher Message Recieved in the foreground--->" +
          notification.toString());
      final data = Map.castFrom<dynamic, dynamic, String, dynamic>(
          notification["data"] as Map<dynamic, dynamic>);
      if (data["interest"] != null) {
        final notificationData = NotificationData(
          interest: data["interest"] as String,
          title: notification["title"] as String,
          body: notification["body"] as String?,
          data: data,
          image: notification["image"] as String?,
          createdAt: notification["createdAt"] as DateTime?,
        );
        notificationHandler(context, notificationData);
      } else {
        logger.warning("Notification data didn't contained interest field");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    //Dynamic Links Handling
    //Background
    handleDynamicLinkOpenedFromBackgroundState();
    //Terminated
    handleDynamicLinkFromTerminatedState();

    //Notifications Handling
    //Called in Background or Terminated State
    FirebaseMessaging.onBackgroundMessage(handlebgmessage);
    //Foreground
    handleNotificationInForegroundState();
    //Terminated
    handleMessagesFromTerminatedState();
    //Background
    handlemessagesthatopenedtheappFromBackgroundState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        _timerLink = new Timer(
          const Duration(milliseconds: 1000),
          () {
            //  handlemessagesthatopenedtheappFromBackgroundState();
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
