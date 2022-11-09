// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tfr_properties.freezed.dart';
part 'tfr_properties.g.dart';

@freezed
abstract class TFRProperties implements _$TFRProperties {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory TFRProperties({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    @JsonKey(name: 'radiusArc') required int radiusArc,
    @JsonKey(name: 'id') required String id,
  }) = _TFRProperties;
  const TFRProperties._();

  factory TFRProperties.fromJson(Map<String, dynamic> json) =>
      _$TFRPropertiesFromJson(json);
}
