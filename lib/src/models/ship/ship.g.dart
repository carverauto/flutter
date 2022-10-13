// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Ship _$$_ShipFromJson(Map<String, dynamic> json) => _$_Ship(
      name: json['name'] as String,
      mmsi: json['mmsi'] as int,
      type: json['type'] as int,
      lat: (json['latitude'] as num).toDouble(),
      lon: (json['longitude'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ShipToJson(_$_Ship instance) => <String, dynamic>{
      'name': instance.name,
      'mmsi': instance.mmsi,
      'type': instance.type,
      'latitude': instance.lat,
      'longitude': instance.lon,
      'heading': instance.heading,
    };
