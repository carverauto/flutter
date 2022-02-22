// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chase _$$_ChaseFromJson(Map<String, dynamic> json) => _$_Chase(
      id: json['id'] as String,
      name: json['Name'] as String?,
      live: json['Live'] as bool?,
      createdAt: const DatetimeTimestampNullableConverter()
          .fromJson(json['CreatedAt'] as Timestamp?),
      desc: json['Desc'] as String?,
      imageURL: json['ImageURL'] as String?,
      votes: json['Votes'] as int?,
      networks: (json['Networks'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      sentiment: json['sentiment'] as Map<String, dynamic>?,
      wheels: json['Wheels'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$_ChaseToJson(_$_Chase instance) => <String, dynamic>{
      'id': instance.id,
      'Name': instance.name,
      'Live': instance.live,
      'CreatedAt':
          const DatetimeTimestampNullableConverter().toJson(instance.createdAt),
      'Desc': instance.desc,
      'ImageURL': instance.imageURL,
      'Votes': instance.votes,
      'Networks': instance.networks,
      'sentiment': instance.sentiment,
      'Wheels': instance.wheels,
    };
