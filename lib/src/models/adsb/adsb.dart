// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'adsb.freezed.dart';
part 'adsb.g.dart';

@freezed
abstract class ADSB implements _$ADSB {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ADSB({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    @JsonKey(name: 'flight') String? flight,
    @JsonKey(name: 'group') String? group,
    @JsonKey(name: 'lat') required double lat,
    @JsonKey(name: 'lon') required double lon,
    @JsonKey(name: 'track') double? track,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'imageUrl') String? imageUrl,
  }) = _ADSB;
  const ADSB._();

  factory ADSB.fromJson(Map<String, dynamic> json) => _$ADSBFromJson(json);
}
