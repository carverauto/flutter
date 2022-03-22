import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverPaginatedListViewAll.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FirehoseListViewAll extends StatelessWidget {
  FirehoseListViewAll({Key? key}) : super(key: key);

  final Logger logger = Logger("FirehoseListViewAll");

  @override
  Widget build(BuildContext context) {
    return SliversPaginatedListViewAll<Activity>(
      itemsPaginationProvider: firehosePaginatedStateNotifierProvier(logger),
      title: "Firehose",
      logger: logger,
      builder: (controller, itemsPaginationProvider) =>
          SliverProviderPaginatedStateNotifierBuilder<Activity>(
              axis: Axis.vertical,
              scrollController: controller,
              builder: (notifications, controller) {
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
                            final notification = notifications[index];
                            return ListTile(
                              title: Text(notification.actor ?? "NA"),
                            ); // NotificationTile(notification: notification);
                          },
                          childCount: notifications.length,
                        ),
                      );
              },
              watchThisStateNotifierProvider: itemsPaginationProvider,
              logger: logger),
    );
  }
}
