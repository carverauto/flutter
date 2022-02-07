// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserData _$$_UserDataFromJson(Map<String, dynamic> json) => _$_UserData(
      uid: json['uid'] as String,
      userName: json['userName'] as String?,
      email: json['email'] as String,
      photoURL: json['photoURL'] as String?,
      lastUpdated: json['lastUpdated'] as int,
      lastTokenUpdate: const DatetimeTimestampNullableConverter()
          .fromJson(json['lastTokenUpdate'] as Timestamp?),
      tokens:
          (json['tokens'] as List<dynamic>?)?.map((e) => e as String).toList(),
      pushTokens: (json['pushTokens'] as List<dynamic>?)
          ?.map((e) => PushToken.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_UserDataToJson(_$_UserData instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'email': instance.email,
      'photoURL': instance.photoURL,
      'lastUpdated': instance.lastUpdated,
      'lastTokenUpdate': const DatetimeTimestampNullableConverter()
          .toJson(instance.lastTokenUpdate),
      'tokens': instance.tokens,
      'pushTokens': instance.pushTokens?.map((e) => e.toJson()).toList(),
    };
