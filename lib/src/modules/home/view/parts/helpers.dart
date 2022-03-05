import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/notification/notification_data/notification_data.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

ChaseAppNotification getNotificationDataFromMessage(RemoteMessage message) {
  final data = message.data;

  final notificationData = ChaseAppNotification(
    interest: data["interest"] as String,
    title: message.notification?.title ?? "NA",
    body: message.notification?.body ?? "NA",
    image: data["image"] as String?,
    data: data["data"] != null
        ? NotificationData.fromJson(data["data"] as Map<String, dynamic>)
        : null,
    id: data["id"] as String?,
    createdAt: data["createdAt"] as DateTime?,
  );

  return notificationData;
}

Future<void> handlebgmessage(RemoteMessage message) async {
  if (message.data["interest"] != null) {
    // updateNotificationsPresentStatus(true);
    final notificationData = getNotificationDataFromMessage(message);

    log("Background message arrived--->" + notificationData.data.toString());

    switch (notificationData.getInterestEnumFromName) {
      case Interests.appUpdates:
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final bool should_fetch = notificationData.data?.configState == "stale";
        await prefs.setBool("should_fetch", should_fetch);
        break;

      default:
    }
  }
}

void updateNotificationsPresentStatus(WidgetRef ref, bool isPresent) async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  // prefs.setBool("newNotificationsPresent", isPresent);
  ref.read(newNotificationsPresentProvider.state).update((state) => isPresent);
}
