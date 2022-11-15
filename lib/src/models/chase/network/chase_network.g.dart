// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chase_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChaseNetwork _$$_ChaseNetworkFromJson(Map<String, dynamic> json) =>
    _$_ChaseNetwork(
      logo: json['Logo'] as String?,
      name: json['Name'] as String?,
      other: json['Other'] as String?,
      tier: json['Tier'] as int?,
      url: json['URL'] as String?,
      mp4Url: json['MP4URL'] as String?,
    );

Map<String, dynamic> _$$_ChaseNetworkToJson(_$_ChaseNetwork instance) =>
    <String, dynamic>{
      'Logo': instance.logo,
      'Name': instance.name,
      'Other': instance.other,
      'Tier': instance.tier,
      'URL': instance.url,
      'MP4URL': instance.mp4Url,
    };
