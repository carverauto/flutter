// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geometry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BOFGeometry _$$_BOFGeometryFromJson(Map<String, dynamic> json) =>
    _$_BOFGeometry(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$_BOFGeometryToJson(_$_BOFGeometry instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'type': instance.type,
    };
