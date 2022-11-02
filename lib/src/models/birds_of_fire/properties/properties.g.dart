// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BofProperties _$$_BofPropertiesFromJson(Map<String, dynamic> json) =>
    _$_BofProperties(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      type: json['type'] as String,
      group: json['group'] as String,
      dbscan: json['dbscan'] as String,
      cluster: json['cluster'] as int?,
    );

Map<String, dynamic> _$$_BofPropertiesToJson(_$_BofProperties instance) =>
    <String, dynamic>{
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'group': instance.group,
      'dbscan': instance.dbscan,
      'cluster': instance.cluster,
    };
