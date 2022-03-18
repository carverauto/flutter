import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/notification/notification.dart';
import '../../../../models/notification/notification_data/notification_data.dart';
import '../../../../shared/enums/interest_enum.dart';
import '../../../../shared/util/extensions/interest_enum.dart';
import '../../../notifications/view/providers/providers.dart';

ChaseAppNotification constructNotification(
  String id,
  String title,
  String body,
  Map<String, dynamic> data,
) {
  final ChaseAppNotification notification = ChaseAppNotification(
    interest: data['Interest'] as String,
    title: title,
    body: body,
    // image: data["Image"] as String?,
    data: NotificationData.fromJson(data),
    type: data['Type'] as String,
    //  data["Data"] != null
    //     ? NotificationData.fromJson(data["Data"] as Map<String, dynamic>)
    //     : null,
    id: id,
    createdAt: parseDate(data['CreatedAt']),
  );

  return notification;
}

DateTime parseDate(dynamic date) {
  if (date == null) {
    return DateTime.now();
  } else if (date is String) {
    final DateTime? parsedDate = DateTime.tryParse(date);

    return parsedDate ?? DateTime.now();
  } else if (date is int) {
    return DateTime.fromMillisecondsSinceEpoch(date);
  } else if (date is Timestamp) {
    return date.toDate();
  } else {
    return date as DateTime;
  }
}

//TODO: Update with new notification schema
ChaseAppNotification getNotificationDataFromMessage(RemoteMessage message) {
  final ChaseAppNotification notification = constructNotification(
    message.messageId!,
    message.notification?.title ?? 'NA',
    message.notification?.body ?? 'NA',
    message.data,
  );

  return notification;
}

Future<void> handlebgmessage(RemoteMessage message) async {
  //TODO: Update with new notification schema

  if (message.data['Interest'] != null) {
    // updateNotificationsPresentStatus(true);
    final ChaseAppNotification notificationData =
        getNotificationDataFromMessage(message);

    log('Background message arrived--->${notificationData.data}');

    switch (notificationData.getInterestEnumFromName) {
      case Interests.appUpdates:
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final bool shouldFetch = notificationData.data?.configState == 'stale';
        await prefs.setBool('should_fetch', shouldFetch);
        break;

      default:
    }
  }
}

void updateNotificationsPresentStatus(
  WidgetRef ref,
  bool isPresent,
) async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  // prefs.setBool("newNotificationsPresent", isPresent);
  ref
      .read(newNotificationsPresentProvider.state)
      .update((bool state) => isPresent);
}
