// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ship.freezed.dart';
part 'ship.g.dart';

@freezed
abstract class Ship implements _$Ship {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Ship({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    // required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'mmsi') required int mmsi,
    @JsonKey(name: 'type') required int type,
    @JsonKey(name: 'latitude') required double lat,
    @JsonKey(name: 'longitude') required double lon,
    @JsonKey(name: 'heading') required double heading,
  }) = _Ship;
  const Ship._();

  factory Ship.fromJson(Map<String, dynamic> json) => _$ShipFromJson(json);
}
