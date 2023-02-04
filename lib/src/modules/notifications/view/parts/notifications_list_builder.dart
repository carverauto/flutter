import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../shared/notifications/notification_tile.dart';
import '../../../../shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import '../../../home/view/parts/helpers.dart';

class NotificationsPaginatedListView extends ConsumerWidget {
  const NotificationsPaginatedListView({
    super.key,
    required this.chasesPaginationProvider,
    required this.logger,
    required this.scrollController,
    this.axis = Axis.horizontal,
  });

  final AutoDisposeStateNotifierProvider<
      PaginationNotifier<ChaseAppNotification>,
      PaginationNotifierState<ChaseAppNotification>> chasesPaginationProvider;
  final Logger logger;
  final ScrollController scrollController;

  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((Duration t) {
      updateNotificationsPresentStatus(ref, false);
    });
    return SliverProviderPaginatedStateNotifierBuilder<ChaseAppNotification>(
        watchThisStateNotifierProvider: chasesPaginationProvider,
        logger: logger,
        scrollController: scrollController,
        axis: axis,
        builder: (List<ChaseAppNotification> notifications, ScrollController controller, [Widget? bottomWidget]) {
          return notifications.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                      ),
                      Chip(
                        label: Text(
                          'No New Notifications!',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return NotificationTile(
                        notification: notifications[index],
                      );
                    },
                    childCount: notifications.length,
                  ),
                );
        },);
  }
}
