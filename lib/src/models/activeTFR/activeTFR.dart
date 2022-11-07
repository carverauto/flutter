// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../birds_of_fire/geometry/geometry.dart';
import 'tfr_properties/tfr_properties.dart';

part 'activeTFR.freezed.dart';
part 'activeTFR.g.dart';

@freezed
abstract class ActiveTFR implements _$ActiveTFR {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ActiveTFR({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    @JsonKey(name: 'geometry') required BOFGeometry geometry,
    @JsonKey(name: 'properties') required TFRProperties properties,
  }) = _ActiveTFR;
  const ActiveTFR._();

  factory ActiveTFR.fromJson(Map<String, dynamic> json) =>
      _$ActiveTFRFromJson(json);
}
