import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/interest/interest.dart';
import '../../../models/notification/notification.dart';
import '../view/providers/providers.dart';
import 'notifications_repo_ab.dart';

class NotificationsRepository implements NotificationsRepoAB {
  NotificationsRepository(this.ref);

  final Ref ref;

  @override
  Future<List<ChaseAppNotification>> fetchNotifications(
    ChaseAppNotification? notificationData,
    String? notificationType,
    String userId,
  ) {
    return ref
        .read(notificationDbProvider)
        .fetchNotifications(notificationData, notificationType, userId);
  }

  @override
  Future<List<Interest>> fetchInterests() {
    return ref.read(notificationDbProvider).fetchInterests();
  }
}
