// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'properties.freezed.dart';
part 'properties.g.dart';

@freezed
abstract class BofProperties implements _$BofProperties {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory BofProperties({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'imageUrl') required String imageUrl,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'group') required String group,
    @JsonKey(name: 'dbscan') required String dbscan,
  }) = _BofProperties;
  const BofProperties._();

  factory BofProperties.fromJson(Map<String, dynamic> json) =>
      _$BofPropertiesFromJson(json);
}
