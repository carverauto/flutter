// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChaseAppNotification _$$_ChaseAppNotificationFromJson(
        Map<String, dynamic> json) =>
    _$_ChaseAppNotification(
      interest: json['Interest'] as String,
      id: json['id'] as String?,
      title: json['Title'] as String?,
      body: json['Body'] as String?,
      image: json['Image'] as String?,
      createdAt: const DatetimeTimestampNullableConverter()
          .fromJson(json['CreatedAt'] as Timestamp?),
      data: json['data'] == null
          ? null
          : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ChaseAppNotificationToJson(
        _$_ChaseAppNotification instance) =>
    <String, dynamic>{
      'Interest': instance.interest,
      'id': instance.id,
      'Title': instance.title,
      'Body': instance.body,
      'Image': instance.image,
      'CreatedAt':
          const DatetimeTimestampNullableConverter().toJson(instance.createdAt),
      'data': instance.data?.toJson(),
    };
