import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/firehose_notification_tile.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FireHoseView extends ConsumerWidget {
  FireHoseView({Key? key}) : super(key: key);

  final Logger _logger = Logger('FireHoseView');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // replace with live stream of firehose with limit to 5
    return SliverProviderPaginatedStateNotifierBuilder<ChaseAppNotification>(
      scrollController: ScrollController(),
      axis: Axis.vertical,
      builder: (notifications, ref) {
        return SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: kItemsSpacingMediumConstant),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final notification = notifications[index];
                return FirehoseNotificationTile(notification: notification);
              },
              childCount: notifications.length,
            ),
          ),
        );
      },
      watchThisStateNotifierProvider:
          firehoseNotificationsStreamProvider(_logger),
      logger: _logger,
    );
  }
}
