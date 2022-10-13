// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birds_of_fire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BirdsOfFire _$$_BirdsOfFireFromJson(Map<String, dynamic> json) =>
    _$_BirdsOfFire(
      geometry: BOFGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
      properties:
          BofProperties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_BirdsOfFireToJson(_$_BirdsOfFire instance) =>
    <String, dynamic>{
      'geometry': instance.geometry.toJson(),
      'properties': instance.properties.toJson(),
    };
