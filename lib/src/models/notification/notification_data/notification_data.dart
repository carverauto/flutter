import 'package:freezed_annotation/freezed_annotation.dart';

import '../../tweet_data/tweet_data.dart';
import '../../youtube_data/youtube_data.dart';

part 'notification_data.freezed.dart';
part 'notification_data.g.dart';

@freezed
abstract class NotificationData implements _$NotificationData {
  @JsonSerializable(explicitToJson: true)
  const factory NotificationData({
    @JsonKey(name: 'Id') String? id,
    @JsonKey(name: 'Image') String? image,
    @JsonKey(name: 'YoutubeId') String? youtubeId,
    @JsonKey(name: 'Tweetid') String? tweetId,
    @JsonKey(name: 'ChannelId') String? channelId,
    @JsonKey(name: 'ConfigState') String? configState,
    TweetData? tweetData,
    YoutubeData? youtubeData,
  }) = _NotificationData;
  const NotificationData._();
  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
}
