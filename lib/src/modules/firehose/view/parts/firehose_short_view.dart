import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/firehose_notification_tile.dart';
import 'package:flutter/material.dart';

class FirehoseShortView extends StatefulWidget {
  const FirehoseShortView({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  final List<ChaseAppNotification> notifications;

  @override
  State<FirehoseShortView> createState() => _FirehoseShortViewState();
}

class _FirehoseShortViewState extends State<FirehoseShortView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.all(kPaddingMediumConstant),
      color: Colors.white,
      child: ListView.builder(
          itemCount: widget.notifications.length,
          itemBuilder: (context, index) {
            return widget.notifications.isEmpty
                ? SizedBox.shrink()
                : FirehoseNotificationTile(
                    notification: widget.notifications[index],
                  );
          }),
    );
  }
}
