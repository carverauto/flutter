import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

NotificationData getNotificationDataFromMessage(RemoteMessage message) {
  final data = message.data;

  final imageUrl = Platform.isAndroid
      ? message.notification?.android?.imageUrl
      : message.notification?.apple?.imageUrl;

  final notificationData = NotificationData(
    interest: data["interest"] as String,
    title: message.notification?.title ?? "NA",
    body: message.notification?.body ?? "NA",
    image: data["image"] as String?,
    data: data,
    id: data["id"] as String?,
    createdAt: data["createdAt"] as DateTime?,
  );

  return notificationData;
}

Future<void> handlebgmessage(RemoteMessage message) async {
  if (message.data["interest"] != null) {
    final notificationData = getNotificationDataFromMessage(message);

    log("Background message arrived--->" + notificationData.data.toString());

    switch (notificationData.getInterestEnumFromName) {
      case Interests.appUpdates:
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final bool should_fetch =
            notificationData.data?["config_state"] == "stale";
        await prefs.setBool("should_fetch", should_fetch);
        break;

      default:
    }
  }
}
