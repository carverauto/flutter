import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/modules/home/view/pages/home_page.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

//TODO: Update configurations for dynamic links for android and ios
// also check for notifications configurations

Future<void> handlebgmessage(RemoteMessage event) async {
  log(event.data.toString());
  print(
      'this is called if app is in background no matter when user opens the app');
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

class HomeWrapper extends ConsumerStatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends ConsumerState<HomeWrapper>
    with WidgetsBindingObserver {
  Timer? _timerLink;

  Future<void> navigateToView(WidgetRef ref, Uri deepLink) async {
    final chaseId = deepLink.queryParameters["chaseId"];

    Navigator.pushNamed(context, RouteName.CHASE_VIEW, arguments: {
      "chaseId": chaseId,
    });
  }

  void handledynamiclink(WidgetRef ref, BuildContext context) async {
    // FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
    //   final Uri? deepLink = dynamicLink.link;

    //   if (deepLink != null) {
    //     await navigateToView(ref, deepLink);
    //   }
    // }, onError: (Object error, StackTrace stackTrace) {
    //   log("Error while recieving message", error: error);
    // });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      await navigateToView(ref, deepLink);
    }
  }

  void handlenotifications(RemoteMessage message) {
    log(message.data.toString());
    Fluttertoast.showToast(
        msg: message.data.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    switch (message.data["type"]) {
      //TODO: Add cases for notification types
      case 'chat':
        break;
      default:
    }
  }

  void handlemessagesthatopenedtheapp(BuildContext context) async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      handlenotifications(message);
    }

    FirebaseMessaging.onBackgroundMessage(handlebgmessage);

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

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        await navigateToView(ref, deepLink);
      }
    }, onError: (Object error, StackTrace stackTrace) {
      log("Error while recieving message", error: error);
    });

    handledynamiclink(ref, context);
    handlemessagesthatopenedtheapp(context);
    FirebaseMessaging.onMessage.listen((event) {
      if (event.data.isNotEmpty) {
        handlenotifications(event);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        _timerLink = new Timer(
          const Duration(milliseconds: 1000),
          () {
            // handledynamiclink(ref, context);
            handlemessagesthatopenedtheapp(context);
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
