// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'weather_station/weather_station.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

@freezed
abstract class Weather implements _$Weather {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Weather({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    @JsonKey(name: 'stations') required List<WeatherStation> stations,
  }) = _Weather;
  const Weather._();

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
