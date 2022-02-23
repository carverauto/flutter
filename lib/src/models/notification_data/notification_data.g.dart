// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationData _$$_NotificationDataFromJson(Map<String, dynamic> json) =>
    _$_NotificationData(
      id: json['id'] as String,
      title: json['title'] as String?,
      body: json['body'] as String?,
      createdAt: const DatetimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$_NotificationDataToJson(_$_NotificationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt':
          const DatetimeTimestampConverter().toJson(instance.createdAt),
      'data': instance.data,
    };
