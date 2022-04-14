// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TweetData _$$_TweetDataFromJson(Map<String, dynamic> json) => _$_TweetData(
      tweetId: json['tweetId'] as String,
      text: json['text'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
    );

Map<String, dynamic> _$$_TweetDataToJson(_$_TweetData instance) =>
    <String, dynamic>{
      'tweetId': instance.tweetId,
      'text': instance.text,
      'userId': instance.userId,
      'userName': instance.userName,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
    };
