import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/sizings.dart';
import '../../core/top_level_providers/services_providers.dart';
import '../../models/notification/notification.dart';
import '../../modules/firehose/view/parts/twitter_preview.dart';
import '../../modules/firehose/view/parts/youtube_preview.dart';
import '../../routes/routeNames.dart';
import '../enums/firehose_notification_type.dart';
import '../enums/interest_enum.dart';
import '../util/extensions/interest_enum.dart';
import '../widgets/hero_dialog_route.dart';
import 'notification_dialog.dart';

// Used to responce to notification taps anywhere in the app and take proper actions.
Future<void> notificationHandler(
  BuildContext context,
  ChaseAppNotification notification, {
  Reader? read,
}) async {
  switch (notification.getInterestEnumFromName) {
    case Interests.chases:
      if (notification.data?.id != null) {
        navigateToChaseView(context, notification.data!.id!);
      }

      break;

    case Interests.appUpdates:
      if (read != null) {
        await read(checkForUpdateStateNotifier.notifier).checkForUpdate(true);
      }
      // handlebgmessage(notification).then<void>(
      //   (value) => read != null
      //       ? read(checkForUpdateStateNotifier.notifier).checkForUpdate(true)
      //       : null,
      // );
      break;
    case Interests.firehose:
      await _showFirehosePreview(notification, context);

      break;

    default:
      await Navigator.push(
        context,
        HeroDialogRoute<void>(
          builder: (BuildContext context) {
            return NotificationDialog(
              notification: notification,
            );
          },
        ),
      );
  }
}

Future<void> _showFirehosePreview(
  ChaseAppNotification notification,
  BuildContext context,
) async {
  // create a new custom route for
  final FirehoseNotificationType? firehoseNotificationType =
      getFirehoseNotificationTypeFromString(notification.type);

  switch (firehoseNotificationType) {
    case FirehoseNotificationType.twitter:
      await _showNotificationDialog(
        context,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kPaddingMediumConstant),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TweetPreview(
                tweetId: notification.data!.tweetId!,
                showMedia: false,
              ),
            ],
          ),
        ),
      );
      break;
    case FirehoseNotificationType.streams:
      await _showNotificationDialog(
        context,
        YoutubePreview(
          notification: notification,
        ),
      );

      break;

    case FirehoseNotificationType.live_on_patrol:
      navigateToChaseView(context, notification.data!.id!);
      break;
    default:
      await Navigator.push(
        context,
        HeroDialogRoute<void>(
          builder: (BuildContext context) {
            return NotificationDialog(
              notification: notification,
            );
          },
        ),
      );
      break;
    // default:
    //   Navigator.push(
    //     context,
    //     HeroDialogRoute<void>(
    //       builder: (context) {
    //         return NotificationDialog(
    //           notification: notification,
    //         );
    //       },
    //     ),
    //   );
  }
}

void navigateToChaseView(BuildContext context, String chaseId) {
  Navigator.pushNamed(
    context,
    RouteName.CHASE_VIEW,
    arguments: <String, dynamic>{
      'chaseId': chaseId,
    },
  );
}

Future<void> _showNotificationDialog(BuildContext context, Widget child) async {
  // create a new custom route for
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return child;
    },
  );
}
