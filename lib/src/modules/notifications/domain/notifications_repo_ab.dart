import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification/notification.dart';

abstract class NotificationsRepoAB {
  Future<List<ChaseAppNotification>> fetchNotifications(
      ChaseAppNotification? notificationData,
      String? notificationType,
      String userId);

  Future<List<Interest>> fetchInterests();
}
