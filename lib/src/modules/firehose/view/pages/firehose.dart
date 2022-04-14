import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../shared/notifications/notification_tile.dart';
import '../../../../shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import '../../../../shared/widgets/loaders/shimmer_tile.dart';

class FireHoseView extends ConsumerWidget {
  const FireHoseView({
    Key? key,
    required this.itemsPaginationProvider,
    required this.scrollController,
    required this.showLimited,
    required this.logger,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<
      PaginationNotifier<ChaseAppNotification>,
      PaginationNotifierState<ChaseAppNotification>> itemsPaginationProvider;
  final ScrollController scrollController;
  final bool showLimited;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverProviderPaginatedStateNotifierBuilder<ChaseAppNotification>(
      axis: Axis.vertical,
      scrollController: scrollController,
      loadingBuilder: () {
        return const ShimmerTile(height: 68);
      },
      builder: (
        List<ChaseAppNotification> notifications,
        ScrollController controller,
      ) {
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
                    final ChaseAppNotification notification =
                        notifications[index];

                    return NotificationTile(notification: notification);
                  },
                  childCount: showLimited
                      ? notifications.length >= 5
                          ? 5
                          : notifications.length
                      : notifications.length,
                ),
              );
      },
      watchThisStateNotifierProvider: itemsPaginationProvider,
      logger: logger,
    );
  }
}
