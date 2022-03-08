import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/twitter_preview.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/youtube_preview.dart';
import 'package:chaseapp/src/shared/enums/firehose_notification_type.dart';
import 'package:flutter/material.dart';

void showFirehosePreview(
    ChaseAppNotification notification, BuildContext context) async {
  // create a new custom route for
  final firehoseNotificationType =
      getFirehoseNotificationTypeFromString(notification.title);
  await showDialog<void>(
      context: context,
      builder: (context) {
        switch (firehoseNotificationType) {
          case FirehoseNotificationType.twitter:
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kPaddingMediumConstant),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweetPreview(
                    tweetId: notification.data!.tweetId!,
                    showMedia: false,
                  ),
                ],
              ),
            );
          case FirehoseNotificationType.streams:
            return YoutubePreview(
              notification: notification,
            );
          default:
            return Container();
        }
      });
}
