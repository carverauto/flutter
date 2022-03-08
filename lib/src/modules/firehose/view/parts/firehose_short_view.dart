import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/firehose_notification_tile.dart';
import 'package:flutter/material.dart';

class FirehoseShortView extends StatelessWidget {
  const FirehoseShortView({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  final List<ChaseAppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final notification = notifications[index];
          return FirehoseNotificationTile(notification: notification);
        },
        childCount: notifications.length,
      ),
    );
  }
}
