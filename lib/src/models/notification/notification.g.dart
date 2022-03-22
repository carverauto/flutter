// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChaseAppNotification _$$_ChaseAppNotificationFromJson(
        Map<String, dynamic> json) =>
    _$_ChaseAppNotification(
      interest: json['Interest'] as String,
      id: json['id'] as String,
      type: json['Type'] as String,
      title: json['Title'] as String,
      body: json['Body'] as String,
      createdAt: const DatetimeTimestampConverter()
          .fromJson(json['CreatedAt'] as Timestamp),
      data: json['Data'] == null
          ? null
          : NotificationData.fromJson(json['Data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ChaseAppNotificationToJson(
        _$_ChaseAppNotification instance) =>
    <String, dynamic>{
      'Interest': instance.interest,
      'id': instance.id,
      'Type': instance.type,
      'Title': instance.title,
      'Body': instance.body,
      'CreatedAt':
          const DatetimeTimestampConverter().toJson(instance.createdAt),
      'Data': instance.data?.toJson(),
    };
