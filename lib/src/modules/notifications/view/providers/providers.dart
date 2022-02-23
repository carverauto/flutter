import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db_ab.dart';
import 'package:chaseapp/src/modules/notifications/domain/notifications_repo.dart';
import 'package:chaseapp/src/modules/notifications/domain/notifications_repo_ab.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final notificationTypeIdProvider = StateProvider<String?>((ref) => null);
final notificationDbProvider =
    Provider<NotificationsDbAB>((ref) => NotificationsDatabase());
final notificationRepoProvider =
    Provider<NotificationsRepoAB>((ref) => NotificationsRepository(ref.read));

final notificationsStreamProvider = StateNotifierProvider.family<
    PaginationNotifier<NotificationData>,
    PaginationNotifierState<NotificationData>,
    Logger>((ref, logger) {
  final notificationType = ref.watch(notificationTypeIdProvider);

  return PaginationNotifier(
      hitsPerPage: 20,
      logger: logger,
      fetchNextItems: (
        notification,
        offset,
      ) async {
        final user = await ref.read(userStreamProvider.future);
        return ref
            .read(notificationRepoProvider)
            .fetchNotifications(notification, notificationType, user.uid);
      });
});
