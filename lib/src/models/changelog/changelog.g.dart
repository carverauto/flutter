// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changelog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Changelog _$$_ChangelogFromJson(Map<String, dynamic> json) => _$_Changelog(
      version: json['Version'] as String,
      title: json['Title'] as String,
      description: json['Description'] as String,
      updatedOn: const DatetimeTimestampConverter().fromJson(json['updatedOn']),
      imageUrl: json['ImageUrl'] as String?,
    );

Map<String, dynamic> _$$_ChangelogToJson(_$_Changelog instance) =>
    <String, dynamic>{
      'Version': instance.version,
      'Title': instance.title,
      'Description': instance.description,
      'updatedOn':
          const DatetimeTimestampConverter().toJson(instance.updatedOn),
      'ImageUrl': instance.imageUrl,
    };
