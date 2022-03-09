import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/home/view/parts/helpers.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_tile.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationsPaginatedListView extends ConsumerWidget {
  NotificationsPaginatedListView({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
    required this.scrollController,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<
      PaginationNotifier<ChaseAppNotification>,
      PaginationNotifierState<ChaseAppNotification>> chasesPaginationProvider;
  final Logger logger;
  final ScrollController scrollController;

  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance!.addPostFrameCallback((t) {
      updateNotificationsPresentStatus(ref, false);
    });
    return SliverProviderPaginatedStateNotifierBuilder<ChaseAppNotification>(
        watchThisStateNotifierProvider: chasesPaginationProvider,
        logger: logger,
        scrollController: scrollController,
        axis: axis,
        builder: (notifications, controller, [Widget? bottomWidget]) {
          return notifications.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                      ),
                      Chip(
                        label: Text(
                          "No New Notifications!",
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
                    (context, index) {
                      return NotificationTIle(
                        notificationData: notifications[index],
                      );
                    },
                    childCount: notifications.length,
                  ),
                );
        });
  }
}
