// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'adsb.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ADSB _$ADSBFromJson(Map<String, dynamic> json) {
  return _ADSB.fromJson(json);
}

/// @nodoc
mixin _$ADSB {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @JsonKey(name: 'flight')
  String get flight => throw _privateConstructorUsedError;
  @JsonKey(name: 'group')
  String get group => throw _privateConstructorUsedError;
  @JsonKey(name: 'lat')
  double get lat => throw _privateConstructorUsedError;
  @JsonKey(name: 'lon')
  double get lon => throw _privateConstructorUsedError;
  @JsonKey(name: 'track')
  double? get track => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ADSBCopyWith<ADSB> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ADSBCopyWith<$Res> {
  factory $ADSBCopyWith(ADSB value, $Res Function(ADSB) then) =
      _$ADSBCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'flight') String flight,
      @JsonKey(name: 'group') String group,
      @JsonKey(name: 'lat') double lat,
      @JsonKey(name: 'lon') double lon,
      @JsonKey(name: 'track') double? track,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class _$ADSBCopyWithImpl<$Res> implements $ADSBCopyWith<$Res> {
  _$ADSBCopyWithImpl(this._value, this._then);

  final ADSB _value;
  // ignore: unused_field
  final $Res Function(ADSB) _then;

  @override
  $Res call({
    Object? flight = freezed,
    Object? group = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? track = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      flight: flight == freezed
          ? _value.flight
          : flight // ignore: cast_nullable_to_non_nullable
              as String,
      group: group == freezed
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      track: track == freezed
          ? _value.track
          : track // ignore: cast_nullable_to_non_nullable
              as double?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_ADSBCopyWith<$Res> implements $ADSBCopyWith<$Res> {
  factory _$$_ADSBCopyWith(_$_ADSB value, $Res Function(_$_ADSB) then) =
      __$$_ADSBCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'flight') String flight,
      @JsonKey(name: 'group') String group,
      @JsonKey(name: 'lat') double lat,
      @JsonKey(name: 'lon') double lon,
      @JsonKey(name: 'track') double? track,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class __$$_ADSBCopyWithImpl<$Res> extends _$ADSBCopyWithImpl<$Res>
    implements _$$_ADSBCopyWith<$Res> {
  __$$_ADSBCopyWithImpl(_$_ADSB _value, $Res Function(_$_ADSB) _then)
      : super(_value, (v) => _then(v as _$_ADSB));

  @override
  _$_ADSB get _value => super._value as _$_ADSB;

  @override
  $Res call({
    Object? flight = freezed,
    Object? group = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? track = freezed,
    Object? type = freezed,
  }) {
    return _then(_$_ADSB(
      flight: flight == freezed
          ? _value.flight
          : flight // ignore: cast_nullable_to_non_nullable
              as String,
      group: group == freezed
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      track: track == freezed
          ? _value.track
          : track // ignore: cast_nullable_to_non_nullable
              as double?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ADSB extends _ADSB {
  const _$_ADSB(
      {@JsonKey(name: 'flight') required this.flight,
      @JsonKey(name: 'group') required this.group,
      @JsonKey(name: 'lat') required this.lat,
      @JsonKey(name: 'lon') required this.lon,
      @JsonKey(name: 'track') this.track,
      @JsonKey(name: 'type') required this.type})
      : super._();

  factory _$_ADSB.fromJson(Map<String, dynamic> json) => _$$_ADSBFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @override
  @JsonKey(name: 'flight')
  final String flight;
  @override
  @JsonKey(name: 'group')
  final String group;
  @override
  @JsonKey(name: 'lat')
  final double lat;
  @override
  @JsonKey(name: 'lon')
  final double lon;
  @override
  @JsonKey(name: 'track')
  final double? track;
  @override
  @JsonKey(name: 'type')
  final String type;

  @override
  String toString() {
    return 'ADSB(flight: $flight, group: $group, lat: $lat, lon: $lon, track: $track, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ADSB &&
            const DeepCollectionEquality().equals(other.flight, flight) &&
            const DeepCollectionEquality().equals(other.group, group) &&
            const DeepCollectionEquality().equals(other.lat, lat) &&
            const DeepCollectionEquality().equals(other.lon, lon) &&
            const DeepCollectionEquality().equals(other.track, track) &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(flight),
      const DeepCollectionEquality().hash(group),
      const DeepCollectionEquality().hash(lat),
      const DeepCollectionEquality().hash(lon),
      const DeepCollectionEquality().hash(track),
      const DeepCollectionEquality().hash(type));

  @JsonKey(ignore: true)
  @override
  _$$_ADSBCopyWith<_$_ADSB> get copyWith =>
      __$$_ADSBCopyWithImpl<_$_ADSB>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ADSBToJson(
      this,
    );
  }
}

abstract class _ADSB extends ADSB {
  const factory _ADSB(
      {@JsonKey(name: 'flight') required final String flight,
      @JsonKey(name: 'group') required final String group,
      @JsonKey(name: 'lat') required final double lat,
      @JsonKey(name: 'lon') required final double lon,
      @JsonKey(name: 'track') final double? track,
      @JsonKey(name: 'type') required final String type}) = _$_ADSB;
  const _ADSB._() : super._();

  factory _ADSB.fromJson(Map<String, dynamic> json) = _$_ADSB.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @JsonKey(name: 'flight')
  String get flight;
  @override
  @JsonKey(name: 'group')
  String get group;
  @override
  @JsonKey(name: 'lat')
  double get lat;
  @override
  @JsonKey(name: 'lon')
  double get lon;
  @override
  @JsonKey(name: 'track')
  double? get track;
  @override
  @JsonKey(name: 'type')
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$_ADSBCopyWith<_$_ADSB> get copyWith => throw _privateConstructorUsedError;
}
