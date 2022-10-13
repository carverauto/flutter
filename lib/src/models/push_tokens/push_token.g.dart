// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PushToken _$$_PushTokenFromJson(Map<String, dynamic> json) => _$_PushToken(
      token: json['token'] as String,
      created_at: json['created_at'] as int,
      device: $enumDecode(_$DeviceOSEnumMap, json['device']),
      type: $enumDecode(_$TokenTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$_PushTokenToJson(_$_PushToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'created_at': instance.created_at,
      'device': _$DeviceOSEnumMap[instance.device]!,
      'type': _$TokenTypeEnumMap[instance.type]!,
    };

const _$DeviceOSEnumMap = {
  DeviceOS.ios: 'ios',
  DeviceOS.android: 'android',
};

const _$TokenTypeEnumMap = {
  TokenType.FCM: 'FCM',
};
