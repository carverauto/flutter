import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
  WidgetRef? ref,
}) async {
  switch (notification.getInterestEnumFromName) {
    case Interests.chases:
      if (notification.data?.id != null) {
        navigateToChaseView(context, notification.data!.id!);
      }

      break;

    case Interests.appUpdates:
      if (ref != null) {
        await ref
            .read(checkForUpdateStateNotifier.notifier)
            .checkForUpdate(true);
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

// ignore: long-method
Future<void> _showFirehosePreview(
  ChaseAppNotification notification,
  BuildContext context,
) async {
  // create a new custom route for
  final FirehoseNotificationType? firehoseNotificationType =
      getFirehoseNotificationTypeFromString(notification.type);

  switch (firehoseNotificationType) {
    case FirehoseNotificationType.twitter:
      final String? tweetId =
          notification.data?.tweetData?.tweetId ?? notification.data?.tweetId;
      if (tweetId == null) {
        Logger('showFirehosePreview').warning(
          'Tweetid missing in twitter notifcation : ${notification.data?.toJson()}',
        );
        return;
      }
      await _showNotificationDialog(
        context,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kPaddingMediumConstant),
          ),
          clipBehavior: Clip.hardEdge,
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TweetPreview(
                tweetId: tweetId,
                showMedia: false,
              ),
            ],
          ),
        ),
      );
      break;
    case FirehoseNotificationType.streams:
      if (notification.data?.youtubeData == null) {
        return;
      }
      await _showNotificationDialog(
        context,
        YoutubePreview(
          videoId: notification.data!.youtubeData!.videoId,
          body: notification.data!.youtubeData!.text,
        ),
      );

      break;

    case FirehoseNotificationType.chase:
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
