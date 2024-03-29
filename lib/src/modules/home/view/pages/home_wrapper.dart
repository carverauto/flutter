import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../const/app_bundle_info.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../models/notification/notification.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/notifications/notification_handler.dart';
import '../../../../shared/notifications/notification_pop_up_banner.dart';
import '../../../../shared/notifications/notifications_helpers.dart';
import '../../../../shared/util/helpers/request_permissions.dart';
import '../../../../shared/util/helpers/sizescaleconfig.dart';
import '../../../dashboard/view/pages/dashboard.dart';
import '../parts/helpers.dart';

class HomeWrapper extends ConsumerStatefulWidget {
  const HomeWrapper({super.key});

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends ConsumerState<HomeWrapper>
    with WidgetsBindingObserver {
  final Logger logger = Logger('HomeWrapper');
  Timer? _timerLink;

  Future<void> navigateToView(Uri deepLink) async {
    final String? chaseId = deepLink.queryParameters['chaseId'];

    await Navigator.pushNamed(
      context,
      RouteName.CHASE_VIEW,
      arguments: {
        'chaseId': chaseId,
      },
    );
  }

  Future<void> handleDynamicLinkFromTerminatedState() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (!ref
        .read(firebaseAuthProvider)
        .isSignInWithEmailLink(deepLink.toString())) {
      if (deepLink != null) {
        await navigateToView(deepLink);
      }
    }
  }

  Future<void> handlenotifications(RemoteMessage message) async {
    log('ChaseAppNotification Message Arrived--->${message.data}');

    final Map<String, dynamic> data = message.data;
    //TODO: Update with new notification schema

    if (data['Interest'] != null && data['Type'] != null) {
      await updateNotificationsPresentStatus(ref, true);
      final ChaseAppNotification notificationData =
          getNotificationDataFromMessage(message);

      await notificationHandler(context, notificationData, ref: ref);
    } else {
      logger.warning(
        "ChaseAppNotification data didn't contained Interest or Type field--> $data",
      );
    }
  }

  Future<void> handleMessagesFromTerminatedState() async {
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    final Map<String, dynamic>? pusherMessage =
        await PusherBeams.instance.getInitialMessage();

    if (message != null) {
      await handlenotifications(message);
      return;
    }
    if (pusherMessage != null) {
      await handlePusherNotification(pusherMessage);
      return;
    }
  }

  Future<void> handlemessagesthatopenedtheappFromBackgroundState() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      if (event.data.isNotEmpty) {
        handlenotifications(event);
      }
    });
  }

  void handleDynamicLinkOpenedFromBackgroundState() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        log('Dynamic Link Recieved--->${dynamicLink.link}');
        final Uri deepLink = dynamicLink.link;
//TODO: Replace with FirebaseAuth.instance.isSignInWithEmailLink(emailLink) check
        if (!ref
            .read(firebaseAuthProvider)
            .isSignInWithEmailLink(deepLink.toString())) {
          if (deepLink != null) {
            await navigateToView(deepLink);
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        log('Error while recieving dynamic link', error: error);
      },
    );
  }

  Future<void> handleNotificationInForegroundState() async {
    final bool checkForPermission = await checkForPermissionsStatuses();
    if (!checkForPermission) {
      return;
    }
    await PusherBeams.instance
        .onMessageReceivedInTheForeground((Map<Object?, Object?> message) {
      log('Pusher Message Recieved in the foreground--->$message');
      handlePusherNotification(message);
    });
  }

  Future<void> handlePusherNotification(Map<dynamic, dynamic> message) async {
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(message['data'] as Map<dynamic, dynamic>);
    //TODO: Update with new notification schema
    if (data['Interest'] != null && data['Type'] != null) {
      final ChaseAppNotification notification = constructNotification(
        math.Random().nextInt(10000).toString(),
        message['title'] as String? ?? 'NA',
        message['body'] as String? ?? 'NA',
        data,
      );
      await updateNotificationsPresentStatus(ref, true);
      // final Interests? notificationType =
      //     getInterestEnumFromString(notification.interest);

      // if (notificationType == Interests.firehose) {
      //   await notificationHandler(
      //     context,
      //     notification,
      //     ref: ref,
      //   );
      //   return;
      // }

      await showNotificationBanner(context, notification);
    } else {
      logger.warning(
        "ChaseAppNotification data didn't contained Interest or Type field--> $data",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      final bool isNotificationsPermissionGranted =
          await checkForPermissionsStatuses();

      if (isNotificationsPermissionGranted) {
        await PusherBeams.instance.start(EnvVaribales.instanceId);
      }
      initPostLoginActions();
      //Dynamic Links Handling
      //Background
      handleDynamicLinkOpenedFromBackgroundState();
      //Terminated
      await handleDynamicLinkFromTerminatedState();

      //Notifications Handling
      //Called in Background or Terminated State
      FirebaseMessaging.onBackgroundMessage(handlebgmessage);
      //Foreground
      await handleNotificationInForegroundState();
      //Terminated
      await handleMessagesFromTerminatedState();
      //Background
      await handlemessagesthatopenedtheappFromBackgroundState();
    });
  }

  void initPostLoginActions() {
    ref.read(postLoginStateNotifierProvider.notifier).initPostLoginActions();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Sizescaleconfig.setSizes(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).textScaleFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dashboard();
  }
}
