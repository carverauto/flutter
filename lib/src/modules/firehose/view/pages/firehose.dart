import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FireHoseView extends ConsumerWidget {
  FireHoseView({Key? key}) : super(key: key);

  final Logger _logger = Logger('FireHoseView');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: kItemsSpacingMediumConstant),
      sliver: SliverProviderPaginatedStateNotifierBuilder<Activity>(
          axis: Axis.vertical,
          scrollController: ScrollController(),
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
                      childCount: notifications.length >= 5
                          ? notifications.sublist(0, 5).length
                          : notifications.length,
                    ),
                  );
          },
          watchThisStateNotifierProvider:
              firehosePaginatedStateNotifierProvier(_logger),
          logger: _logger),
    );
  }
}
