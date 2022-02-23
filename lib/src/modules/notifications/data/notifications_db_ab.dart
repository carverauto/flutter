import 'package:chaseapp/src/models/notification_data/notification_data.dart';

abstract class NotificationsDbAB {
  Future<List<NotificationData>> fetchNotifications(
      NotificationData? notificationData,
      String? notificationType,
      String userId);
}
