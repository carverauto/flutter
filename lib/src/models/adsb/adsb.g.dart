// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adsb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ADSB _$$_ADSBFromJson(Map<String, dynamic> json) => _$_ADSB(
      flight: json['flight'] as String?,
      group: json['group'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      track: (json['track'] as num?)?.toDouble(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$_ADSBToJson(_$_ADSB instance) => <String, dynamic>{
      'flight': instance.flight,
      'group': instance.group,
      'lat': instance.lat,
      'lon': instance.lon,
      'track': instance.track,
      'type': instance.type,
    };
