// ignore_for_file: public_member_api_docs, avoid_dynamic_calls, no_default_cases, omit_local_variable_types

// ignore: long-method
import 'package:stream_feed/stream_feed.dart' as feed;

import '../../const/images.dart';
import '../../models/notification/notification.dart';
import '../../models/notification/notification_data/notification_data.dart';
import '../../models/tweet_data/tweet_data.dart';
import '../../models/youtube_data/youtube_data.dart';
import '../enums/firehose_notification_type.dart';
import '../enums/interest_enum.dart';
import '../util/convertors/datetimeconvertor.dart';
import '../util/extensions/interest_enum.dart';

// ignore: long-method
ChaseAppNotification convertActivityToChaseAppNotification(
  feed.Activity activity,
) {
  final String type = activity.extraData!['eventType']! as String;
  final Map<String, dynamic> payload =
      activity.extraData!['payload']! as Map<String, dynamic>;
  final String? title = payload['title'] as String?;
  final String? body = payload['body'] as String?;
  final String? image = payload['image_url'] as String?;
  final DateTime createdAt =
      parseDate(activity.extraData!['created_at']! as int);
  final String? id = payload['id'] as String?;
  late final NotificationData data;
  switch (getFirehoseNotificationTypeFromString(type)) {
    case FirehoseNotificationType.twitter:
      data = NotificationData(
        tweetData: TweetData(
          name: payload['name'] as String,
          text: payload['text'] as String,
          tweetId: payload['id'] as String,
          userId: '',
          userName: payload['username'] as String,
          profileImageUrl: image ?? defaultPhotoURL,
        ),
      );
      break;

    case FirehoseNotificationType.streams:
      data = NotificationData(
        youtubeId: id,
        image: image,
        youtubeData: YoutubeData(
          name: payload['name'] as String,
          text: payload['text'] as String,
          videoId: payload['id'] as String,
          channelId: payload['channelId'] as String,
          userName: payload['username'] as String,
          subcribersCount: payload['subcribersCount'] as int,
          profileImageUrl: image ?? defaultPhotoURL,
        ),
      );
      break;

    case FirehoseNotificationType.chase:
      data = NotificationData(
        id: id,
        image: image,
      );
      break;

    case FirehoseNotificationType.events:
      data = NotificationData(
        // id: id,
        image: image,
      );
      break;

    default:
      data = NotificationData(
        // id: id,
        image: image,
      );
      break;
  }

  return ChaseAppNotification(
    interest: getStringFromInterestEnum(Interests.firehose)!,
    type: type,
    title: title ?? 'NA',
    body: body ?? 'NA',
    id: activity.id!,
    createdAt: createdAt,
    data: data,
  );
}
