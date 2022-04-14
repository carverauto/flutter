// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationData _$$_NotificationDataFromJson(Map<String, dynamic> json) =>
    _$_NotificationData(
      id: json['Id'] as String?,
      image: json['Image'] as String?,
      youtubeId: json['YoutubeId'] as String?,
      channelId: json['ChannelId'] as String?,
      configState: json['ConfigState'] as String?,
      tweetData: json['tweetData'] == null
          ? null
          : TweetData.fromJson(json['tweetData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_NotificationDataToJson(_$_NotificationData instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Image': instance.image,
      'YoutubeId': instance.youtubeId,
      'ChannelId': instance.channelId,
      'ConfigState': instance.configState,
      'tweetData': instance.tweetData?.toJson(),
    };
