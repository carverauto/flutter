// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chase _$$_ChaseFromJson(Map<String, dynamic> json) => _$_Chase(
      id: json['id'] as String,
      name: json['name'] as String,
      live: json['live'] as bool,
      createdAt: const DatetimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
      desc: json['desc'] as String,
      imageURL: json['imageURL'] as String?,
      votes: json['votes'] as int,
      networks: json['networks'] as List<dynamic>?,
      sentiment: json['sentiment'] as Map<String, dynamic>?,
      wheels: json['wheels'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$_ChaseToJson(_$_Chase instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'live': instance.live,
      'createdAt':
          const DatetimeTimestampConverter().toJson(instance.createdAt),
      'desc': instance.desc,
      'imageURL': instance.imageURL,
      'votes': instance.votes,
      'networks': instance.networks,
      'sentiment': instance.sentiment,
      'wheels': instance.wheels,
    };
