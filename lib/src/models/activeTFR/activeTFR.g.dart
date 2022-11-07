// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activeTFR.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActiveTFR _$$_ActiveTFRFromJson(Map<String, dynamic> json) => _$_ActiveTFR(
      id: json['id'] as String,
      geometry: BOFGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
      properties:
          TFRProperties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ActiveTFRToJson(_$_ActiveTFR instance) =>
    <String, dynamic>{
      'id': instance.id,
      'geometry': instance.geometry.toJson(),
      'properties': instance.properties.toJson(),
    };
