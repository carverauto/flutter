import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';

abstract class NotificationsRepoAB {
  Future<List<NotificationData>> fetchNotifications(
      NotificationData? notificationData,
      String? notificationType,
      String userId);

  Future<List<Interest>> fetchInterests();
}
