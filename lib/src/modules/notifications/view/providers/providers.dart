import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/interest/interest.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../data/notifications_db.dart';
import '../../data/notifications_db_ab.dart';
import '../../domain/notifications_repo.dart';
import '../../domain/notifications_repo_ab.dart';

final StateProvider<String?> notificationInterestProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);
final AutoDisposeProvider<NotificationsDbAB> notificationDbProvider =
    Provider.autoDispose<NotificationsDbAB>(
  (AutoDisposeProviderRef<NotificationsDbAB> ref) => NotificationsDatabase(),
);
final AutoDisposeProvider<NotificationsRepoAB> notificationRepoProvider =
    Provider.autoDispose<NotificationsRepoAB>(
  (AutoDisposeProviderRef<NotificationsRepoAB> ref) =>
      NotificationsRepository(ref.read),
);

final AutoDisposeStateNotifierProviderFamily<
        PaginationNotifier<ChaseAppNotification>,
        PaginationNotifierState<ChaseAppNotification>,
        Logger> notificationsStreamProvider =
    StateNotifierProvider.autoDispose.family<
        PaginationNotifier<ChaseAppNotification>,
        PaginationNotifierState<ChaseAppNotification>,
        Logger>((AutoDisposeStateNotifierProviderRef<
                PaginationNotifier<ChaseAppNotification>,
                PaginationNotifierState<ChaseAppNotification>>
            ref,
        Logger logger) {
  final String? notificationType = ref.watch(notificationInterestProvider);
  final User user = ref.read(firebaseAuthProvider).currentUser!;

  return PaginationNotifier(
    hitsPerPage: 20,
    logger: logger,
    fetchNextItems: (
      ChaseAppNotification? notification,
      int offset,
    ) async {
      return ref
          .read(notificationRepoProvider)
          .fetchNotifications(notification, notificationType, user.uid);
    },
  );
});

final AutoDisposeFutureProvider<List<String?>> usersInterestsStreamProvider =
    FutureProvider.autoDispose<List<String?>>(
        (AutoDisposeFutureProviderRef<List<String?>> ref) async {
  final List<String?> usersInterests =
      await ref.read(pusherBeamsProvider).getDeviceInterests();
  usersInterests.sort(
    (String? a, String? b) =>
        a?.toLowerCase().compareTo(b?.toLowerCase() ?? '') ?? -1,
  );
  // For "All"
  final List<String?> finalList = List<String?>.from(usersInterests)
    ..insert(0, null);
  return finalList;
});

final AutoDisposeFutureProvider<List<Interest>> interestsProvider =
    FutureProvider.autoDispose<List<Interest>>(
        (AutoDisposeFutureProviderRef<List<Interest>> ref) async {
  return ref.read(notificationRepoProvider).fetchInterests();
});

final StateProvider<bool> newNotificationsPresentProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) => false);
