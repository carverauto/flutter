import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/firehose_notification_tile.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverPaginatedListViewAll.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FirehoseListViewAll extends StatelessWidget {
  FirehoseListViewAll({Key? key}) : super(key: key);

  final Logger logger = Logger("FirehoseListViewAll");

  @override
  Widget build(BuildContext context) {
    return SliversPaginatedListViewAll<ChaseAppNotification>(
      itemsPaginationProvider: firehoseNotificationsStreamProvider(logger),
      title: "Firehose",
      logger: logger,
      builder: (controller, itemsPaginationProvider) =>
          SliverProviderPaginatedStateNotifierBuilder<ChaseAppNotification>(
        scrollController: ScrollController(),
        axis: Axis.vertical,
        builder: (notifications, ref) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final notification = notifications[index];
                return FirehoseNotificationTile(notification: notification);
              },
              childCount: notifications.length,
            ),
          );
        },
        watchThisStateNotifierProvider:
            firehoseNotificationsStreamProvider(logger),
        logger: logger,
      ),
    );
  }
}
