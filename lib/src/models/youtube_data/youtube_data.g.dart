// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_YoutubeData _$$_YoutubeDataFromJson(Map<String, dynamic> json) =>
    _$_YoutubeData(
      videoId: json['videoId'] as String,
      text: json['text'] as String,
      channelId: json['channelId'] as String,
      userName: json['userName'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      subcribersCount: json['subcribersCount'] as int,
    );

Map<String, dynamic> _$$_YoutubeDataToJson(_$_YoutubeData instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'text': instance.text,
      'channelId': instance.channelId,
      'userName': instance.userName,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'subcribersCount': instance.subcribersCount,
    };
