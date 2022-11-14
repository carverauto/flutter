// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_station.freezed.dart';
part 'weather_station.g.dart';

@freezed
abstract class WeatherStation implements _$WeatherStation {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory WeatherStation({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    @JsonKey(name: 'lat') required double lat,
    @JsonKey(name: 'lng') required double lng,
    @JsonKey(name: 'stormsurge') required bool stormesurge,
  }) = _WeatherStation;
  const WeatherStation._();

  factory WeatherStation.fromJson(Map<String, dynamic> json) =>
      _$WeatherStationFromJson(json);
}
