import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/modules/home/view/pages/home_page.dart';
import 'package:chaseapp/src/modules/home/view/parts/helpers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/notifications/notification_handler.dart';
import 'package:chaseapp/src/shared/notifications/notification_pop_up_banner.dart';
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

    if (deepLink?.path != "/__/auth/action") {
      if (deepLink != null) {
        await navigateToView(deepLink);
      }
    }
  }

  void handlenotifications(RemoteMessage message) async {
    log("ChaseAppNotification Message Arrived--->" + message.data.toString());

    final data = message.data;
    //TODO: Update with new notification schema

    if (data["Interest"] != null && data["Type"] != null) {
      updateNotificationsPresentStatus(ref, true);
      final notificationData = getNotificationDataFromMessage(message);

      notificationHandler(context, notificationData, read: ref.read);
    } else {
      logger.warning(
        "ChaseAppNotification data didn't contained Interest or Type field--> $data",
      );
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

      if (deepLink?.path != "/__/auth/action") {
        if (deepLink != null) {
          await navigateToView(deepLink);
        }
      }
    }, onError: (Object error, StackTrace stackTrace) {
      log("Error while recieving dynamic link", error: error);
    });
  }

  void handleNotificationInForegroundState() {
    PusherBeams.instance.onMessageReceivedInTheForeground((message) {
      log("Pusher Message Recieved in the foreground--->" + message.toString());
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(message["data"] as Map<dynamic, dynamic>);
      //TODO: Update with new notification schema
      if (data["Interest"] != null && data["Type"] != null) {
        final notification = constructNotification(
          message["title"] as String? ?? "NA",
          message["body"] as String? ?? "NA",
          data,
        );
        // final notificationData = ChaseAppNotification(
        //   interest: data["Interest"] as String,
        //   title: notification["Title"] as String,
        //   body: notification["Body"] as String,
        //   data: NotificationData.fromJson(data),
        //   image: data["Image"] as String?,
        //   createdAt: data["CreatedAt"] as DateTime,
        // );
        updateNotificationsPresentStatus(ref, true);

        showNotificationBanner(context, notification);
      } else {
        logger.warning(
          "ChaseAppNotification data didn't contained Interest or Type field--> $data",
        );
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
          () {},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
