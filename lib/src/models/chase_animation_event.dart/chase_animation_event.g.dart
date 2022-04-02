// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chase_animation_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChaseAnimationEvent _$$_ChaseAnimationEventFromJson(
        Map<String, dynamic> json) =>
    _$_ChaseAnimationEvent(
      id: json['id'] as String,
      animtype: const AnimTypeConvertor().fromJson(json['animtype'] as String),
      endpoint: json['endpoint'] as String,
      animstate: json['animstate'] as String,
      label: json['label'] as int,
      videoId: json['videoId'] as String,
      artboard: json['artboard'] as String,
      animations: (json['animations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      alignment:
          const AlignmentConvertor().fromJson(json['alignment'] as String),
      createdAt: const DatetimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$_ChaseAnimationEventToJson(
        _$_ChaseAnimationEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'animtype': const AnimTypeConvertor().toJson(instance.animtype),
      'endpoint': instance.endpoint,
      'animstate': instance.animstate,
      'label': instance.label,
      'videoId': instance.videoId,
      'artboard': instance.artboard,
      'animations': instance.animations,
      'alignment': const AlignmentConvertor().toJson(instance.alignment),
      'createdAt':
          const DatetimeTimestampConverter().toJson(instance.createdAt),
    };
