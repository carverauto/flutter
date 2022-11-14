// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WeatherStation _$$_WeatherStationFromJson(Map<String, dynamic> json) =>
    _$_WeatherStation(
      id: json['id'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      stormesurge: json['stormsurge'] as bool,
    );

Map<String, dynamic> _$$_WeatherStationToJson(_$_WeatherStation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'stormsurge': instance.stormesurge,
    };
