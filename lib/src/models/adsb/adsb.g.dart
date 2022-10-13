// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adsb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ADSB _$$_ADSBFromJson(Map<String, dynamic> json) => _$_ADSB(
      flight: json['flight'] as String,
      group: json['group'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ADSBToJson(_$_ADSB instance) => <String, dynamic>{
      'flight': instance.flight,
      'group': instance.group,
      'lat': instance.lat,
      'lon': instance.lon,
    };
