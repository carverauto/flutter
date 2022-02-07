// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PushToken _$$_PushTokenFromJson(Map<String, dynamic> json) => _$_PushToken(
      Token: json['Token'] as String,
      CreatedAt: json['CreatedAt'] as int,
      Device: json['Device'],
      TokenType: json['TokenType'],
    );

Map<String, dynamic> _$$_PushTokenToJson(_$_PushToken instance) =>
    <String, dynamic>{
      'Token': instance.Token,
      'CreatedAt': instance.CreatedAt,
      'Device': instance.Device,
      'TokenType': instance.TokenType,
    };
