// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'geometry/geometry.dart';
import 'properties/properties.dart';

part 'birds_of_fire.freezed.dart';
part 'birds_of_fire.g.dart';

@freezed
abstract class BirdsOfFire implements _$BirdsOfFire {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory BirdsOfFire({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    // required String id,
    @JsonKey(name: 'geometry') required BOFGeometry geometry,
    @JsonKey(name: 'properties') required BofProperties properties,
  }) = _BirdsOfFire;
  const BirdsOfFire._();

  factory BirdsOfFire.fromJson(Map<String, dynamic> json) =>
      _$BirdsOfFireFromJson(json);
}
