// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Interest _$$_InterestFromJson(Map<String, dynamic> json) => _$_Interest(
      id: json['id'] as String,
      instanceId: json['instanceId'] as String,
      name: json['name'] as String,
      isCompulsory: json['isCompulsory'] as bool,
      isDefault: json['isDefault'] as bool,
      isPremium: json['isPremium'] as bool,
      createdAt: const DatetimeTimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$_InterestToJson(_$_Interest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instanceId': instance.instanceId,
      'name': instance.name,
      'isCompulsory': instance.isCompulsory,
      'isDefault': instance.isDefault,
      'isPremium': instance.isPremium,
      'createdAt':
          const DatetimeTimestampConverter().toJson(instance.createdAt),
    };
