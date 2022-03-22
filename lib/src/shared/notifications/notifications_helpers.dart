import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/notification/notification.dart';
import '../../models/notification/notification_data/notification_data.dart';
import '../util/convertors/datetimeconvertor.dart';

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
    data: NotificationData.fromJson(data),
    type: data['Type'] as String,
    id: id,
    createdAt: parseDate(data['CreatedAt']),
  );

  return notification;
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
