import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/notification/notification_data/notification_data.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/interest_enum.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

ChaseAppNotification constructNotification(
    String title, String body, Map<String, dynamic> data) {
  final notification = ChaseAppNotification(
    interest: data["Interest"] as String,
    title: title,
    body: body,
    image: data["Image"] as String?,
    data: NotificationData.fromJson(data),
    type: data["Type"] as String,
    //  data["Data"] != null
    //     ? NotificationData.fromJson(data["Data"] as Map<String, dynamic>)
    //     : null,
    id: data["Id"] as String?,
    createdAt: data["CreatedAt"] as DateTime,
  );

  return notification;
}

//TODO: Update with new notification schema
ChaseAppNotification getNotificationDataFromMessage(RemoteMessage message) {
  final notification = constructNotification(
    message.notification?.title ?? "NA",
    message.notification?.body ?? "NA",
    message.data,
  );

  return notification;
}

Future<void> handlebgmessage(RemoteMessage message) async {
  //TODO: Update with new notification schema

  if (message.data["Interest"] != null) {
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
