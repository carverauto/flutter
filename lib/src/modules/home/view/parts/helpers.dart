import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/notification/notification.dart';
import '../../../../shared/enums/interest_enum.dart';
import '../../../../shared/notifications/notifications_helpers.dart';
import '../../../../shared/util/extensions/interest_enum.dart';
import '../../../notifications/view/providers/providers.dart';

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
