import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db_ab.dart';
import 'package:chaseapp/src/modules/notifications/domain/notifications_repo.dart';
import 'package:chaseapp/src/modules/notifications/domain/notifications_repo_ab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final notificationInterestProvider = StateProvider<String?>((ref) => null);
final notificationDbProvider =
    Provider.autoDispose<NotificationsDbAB>((ref) => NotificationsDatabase());
final notificationRepoProvider = Provider.autoDispose<NotificationsRepoAB>(
    (ref) => NotificationsRepository(ref.read));

final notificationsStreamProvider = StateNotifierProvider.family<
    PaginationNotifier<NotificationData>,
    PaginationNotifierState<NotificationData>,
    Logger>((ref, logger) {
  final notificationType = ref.watch(notificationInterestProvider);
  final user = ref.read(firebaseAuthProvider).currentUser!;

  return PaginationNotifier(
      hitsPerPage: 20,
      logger: logger,
      fetchNextItems: (
        notification,
        offset,
      ) async {
        return ref
            .read(notificationRepoProvider)
            .fetchNotifications(notification, notificationType, user.uid);
      });
});

final usersInterestsStreamProvider =
    FutureProvider.autoDispose<List<String?>>((ref) async {
  final usersInterests =
      await ref.read(pusherBeamsProvider).getDeviceInterests();
  return usersInterests;
});

final interestsProvider =
    FutureProvider.autoDispose<List<Interest>>((ref) async {
  return ref.read(notificationRepoProvider).fetchInterests();
});
