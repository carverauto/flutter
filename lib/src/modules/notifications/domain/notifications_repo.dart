import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/notifications/domain/notifications_repo_ab.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsRepository implements NotificationsRepoAB {
  NotificationsRepository(this.read);

  final Reader read;

  Future<List<ChaseAppNotification>> fetchNotifications(
      ChaseAppNotification? notificationData,
      String? notificationType,
      String userId) {
    return read(notificationDbProvider)
        .fetchNotifications(notificationData, notificationType, userId);
  }

  @override
  Future<List<Interest>> fetchInterests() {
    return read(notificationDbProvider).fetchInterests();
  }
}
