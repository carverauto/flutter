// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'weather_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WeatherStation _$WeatherStationFromJson(Map<String, dynamic> json) {
  return _WeatherStation.fromJson(json);
}

/// @nodoc
mixin _$WeatherStation {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'lat')
  double get lat => throw _privateConstructorUsedError;
  @JsonKey(name: 'lng')
  double get lng => throw _privateConstructorUsedError;
  @JsonKey(name: 'stormsurge')
  bool get stormesurge => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherStationCopyWith<WeatherStation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherStationCopyWith<$Res> {
  factory $WeatherStationCopyWith(
          WeatherStation value, $Res Function(WeatherStation) then) =
      _$WeatherStationCopyWithImpl<$Res, WeatherStation>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'lat') double lat,
      @JsonKey(name: 'lng') double lng,
      @JsonKey(name: 'stormsurge') bool stormesurge});
}

/// @nodoc
class _$WeatherStationCopyWithImpl<$Res, $Val extends WeatherStation>
    implements $WeatherStationCopyWith<$Res> {
  _$WeatherStationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lat = null,
    Object? lng = null,
    Object? stormesurge = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      stormesurge: null == stormesurge
          ? _value.stormesurge
          : stormesurge // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WeatherStationCopyWith<$Res>
    implements $WeatherStationCopyWith<$Res> {
  factory _$$_WeatherStationCopyWith(
          _$_WeatherStation value, $Res Function(_$_WeatherStation) then) =
      __$$_WeatherStationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'lat') double lat,
      @JsonKey(name: 'lng') double lng,
      @JsonKey(name: 'stormsurge') bool stormesurge});
}

/// @nodoc
class __$$_WeatherStationCopyWithImpl<$Res>
    extends _$WeatherStationCopyWithImpl<$Res, _$_WeatherStation>
    implements _$$_WeatherStationCopyWith<$Res> {
  __$$_WeatherStationCopyWithImpl(
      _$_WeatherStation _value, $Res Function(_$_WeatherStation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lat = null,
    Object? lng = null,
    Object? stormesurge = null,
  }) {
    return _then(_$_WeatherStation(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      stormesurge: null == stormesurge
          ? _value.stormesurge
          : stormesurge // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_WeatherStation extends _WeatherStation {
  const _$_WeatherStation(
      {required this.id,
      @JsonKey(name: 'lat') required this.lat,
      @JsonKey(name: 'lng') required this.lng,
      @JsonKey(name: 'stormsurge') required this.stormesurge})
      : super._();

  factory _$_WeatherStation.fromJson(Map<String, dynamic> json) =>
      _$$_WeatherStationFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  final String id;
  @override
  @JsonKey(name: 'lat')
  final double lat;
  @override
  @JsonKey(name: 'lng')
  final double lng;
  @override
  @JsonKey(name: 'stormsurge')
  final bool stormesurge;

  @override
  String toString() {
    return 'WeatherStation(id: $id, lat: $lat, lng: $lng, stormesurge: $stormesurge)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WeatherStation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.stormesurge, stormesurge) ||
                other.stormesurge == stormesurge));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, lat, lng, stormesurge);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WeatherStationCopyWith<_$_WeatherStation> get copyWith =>
      __$$_WeatherStationCopyWithImpl<_$_WeatherStation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WeatherStationToJson(
      this,
    );
  }
}

abstract class _WeatherStation extends WeatherStation {
  const factory _WeatherStation(
          {required final String id,
          @JsonKey(name: 'lat') required final double lat,
          @JsonKey(name: 'lng') required final double lng,
          @JsonKey(name: 'stormsurge') required final bool stormesurge}) =
      _$_WeatherStation;
  const _WeatherStation._() : super._();

  factory _WeatherStation.fromJson(Map<String, dynamic> json) =
      _$_WeatherStation.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id;
  @override
  @JsonKey(name: 'lat')
  double get lat;
  @override
  @JsonKey(name: 'lng')
  double get lng;
  @override
  @JsonKey(name: 'stormsurge')
  bool get stormesurge;
  @override
  @JsonKey(ignore: true)
  _$$_WeatherStationCopyWith<_$_WeatherStation> get copyWith =>
      throw _privateConstructorUsedError;
}
