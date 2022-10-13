// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'geometry.freezed.dart';
part 'geometry.g.dart';

@freezed
abstract class BOFGeometry implements _$BOFGeometry {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory BOFGeometry({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    @JsonKey(name: 'coordinates') required List<double> coordinates,
    @JsonKey(name: 'type') required String type,
  }) = _BOFGeometry;
  const BOFGeometry._();

  factory BOFGeometry.fromJson(Map<String, dynamic> json) =>
      _$BOFGeometryFromJson(json);
}
