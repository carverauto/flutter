import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/twitter_preview.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/youtube_preview.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/enums/firehose_notification_type.dart';
import 'package:chaseapp/src/shared/enums/interest_enum.dart';
import 'package:chaseapp/src/shared/notifications/notification_dialog.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:chaseapp/src/shared/widgets/hero_dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Used to responce to notification taps anywhere in the app and take proper actions.
Future<void> notificationHandler(
    BuildContext context, ChaseAppNotification notification,
    {Reader? read}) async {
  switch (notification.getInterestEnumFromName) {
    case Interests.chases:
      if (notification.data?.id != null)
        navigateToChaseView(context, notification.data!.id!);

      break;

    case Interests.appUpdates:
      if (read != null)
        read(checkForUpdateStateNotifier.notifier).checkForUpdate(true);
      // handlebgmessage(notification).then<void>(
      //   (value) => read != null
      //       ? read(checkForUpdateStateNotifier.notifier).checkForUpdate(true)
      //       : null,
      // );
      break;
    case Interests.firehose:
      _showFirehosePreview(notification, context);

      break;

    default:
      Navigator.push(
        context,
        HeroDialogRoute<void>(
          builder: (context) {
            return NotificationDialog(
              notification: notification,
            );
          },
        ),
      );
  }
}

void _showFirehosePreview(
    ChaseAppNotification notification, BuildContext context) async {
  // create a new custom route for
  final firehoseNotificationType =
      getFirehoseNotificationTypeFromString(notification.type);

  switch (firehoseNotificationType) {
    case FirehoseNotificationType.twitter:
      _showNotificationDialog(
          context,
          Dialog(
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
          ));
      break;
    case FirehoseNotificationType.streams:
      _showNotificationDialog(
          context,
          YoutubePreview(
            notification: notification,
          ));

      break;

    case FirehoseNotificationType.live_on_patrol:
      navigateToChaseView(context, notification.data!.id!);
      break;
    default:
      Navigator.push(
        context,
        HeroDialogRoute<void>(
          builder: (context) {
            return NotificationDialog(
              notification: notification,
            );
          },
        ),
      );
  }
}

void navigateToChaseView(BuildContext context, String chaseId) {
  Navigator.pushNamed(
    context,
    RouteName.CHASE_VIEW,
    arguments: {
      "chaseId": chaseId,
    },
  );
}

void _showNotificationDialog(BuildContext context, Widget child) async {
  // create a new custom route for
  await showDialog<void>(
      context: context,
      builder: (context) {
        return child;
      });
}
