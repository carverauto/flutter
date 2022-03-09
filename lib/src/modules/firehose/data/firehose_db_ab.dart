import 'package:chaseapp/src/models/notification/notification.dart';

abstract class FirehoseNotificationsDbAB {
  Stream<List<ChaseAppNotification>> streamFirehoseNotifications();

  Future<List<ChaseAppNotification>> fetchNotifications(
      ChaseAppNotification? notificationData);
}
