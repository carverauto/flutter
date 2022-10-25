// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Ship _$ShipFromJson(Map<String, dynamic> json) {
  return _Ship.fromJson(json);
}

/// @nodoc
mixin _$Ship {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'mmsi')
  int? get mmsi => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  int get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'latitude')
  double get lat => throw _privateConstructorUsedError;
  @JsonKey(name: 'longitude')
  double get lon => throw _privateConstructorUsedError;
  @JsonKey(name: 'heading')
  double get heading => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShipCopyWith<Ship> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipCopyWith<$Res> {
  factory $ShipCopyWith(Ship value, $Res Function(Ship) then) =
      _$ShipCopyWithImpl<$Res, Ship>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'mmsi') int? mmsi,
      @JsonKey(name: 'type') int type,
      @JsonKey(name: 'latitude') double lat,
      @JsonKey(name: 'longitude') double lon,
      @JsonKey(name: 'heading') double heading});
}

/// @nodoc
class _$ShipCopyWithImpl<$Res, $Val extends Ship>
    implements $ShipCopyWith<$Res> {
  _$ShipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? mmsi = freezed,
    Object? type = null,
    Object? lat = null,
    Object? lon = null,
    Object? heading = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      mmsi: freezed == mmsi
          ? _value.mmsi
          : mmsi // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ShipCopyWith<$Res> implements $ShipCopyWith<$Res> {
  factory _$$_ShipCopyWith(_$_Ship value, $Res Function(_$_Ship) then) =
      __$$_ShipCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'mmsi') int? mmsi,
      @JsonKey(name: 'type') int type,
      @JsonKey(name: 'latitude') double lat,
      @JsonKey(name: 'longitude') double lon,
      @JsonKey(name: 'heading') double heading});
}

/// @nodoc
class __$$_ShipCopyWithImpl<$Res> extends _$ShipCopyWithImpl<$Res, _$_Ship>
    implements _$$_ShipCopyWith<$Res> {
  __$$_ShipCopyWithImpl(_$_Ship _value, $Res Function(_$_Ship) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? mmsi = freezed,
    Object? type = null,
    Object? lat = null,
    Object? lon = null,
    Object? heading = null,
  }) {
    return _then(_$_Ship(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      mmsi: freezed == mmsi
          ? _value.mmsi
          : mmsi // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: null == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Ship extends _Ship {
  const _$_Ship(
      {required this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'mmsi') this.mmsi,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'latitude') required this.lat,
      @JsonKey(name: 'longitude') required this.lon,
      @JsonKey(name: 'heading') required this.heading})
      : super._();

  factory _$_Ship.fromJson(Map<String, dynamic> json) => _$$_ShipFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  final String id;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'mmsi')
  final int? mmsi;
  @override
  @JsonKey(name: 'type')
  final int type;
  @override
  @JsonKey(name: 'latitude')
  final double lat;
  @override
  @JsonKey(name: 'longitude')
  final double lon;
  @override
  @JsonKey(name: 'heading')
  final double heading;

  @override
  String toString() {
    return 'Ship(id: $id, name: $name, mmsi: $mmsi, type: $type, lat: $lat, lon: $lon, heading: $heading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Ship &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mmsi, mmsi) || other.mmsi == mmsi) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.heading, heading) || other.heading == heading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, mmsi, type, lat, lon, heading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ShipCopyWith<_$_Ship> get copyWith =>
      __$$_ShipCopyWithImpl<_$_Ship>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ShipToJson(
      this,
    );
  }
}

abstract class _Ship extends Ship {
  const factory _Ship(
      {required final String id,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'mmsi') final int? mmsi,
      @JsonKey(name: 'type') required final int type,
      @JsonKey(name: 'latitude') required final double lat,
      @JsonKey(name: 'longitude') required final double lon,
      @JsonKey(name: 'heading') required final double heading}) = _$_Ship;
  const _Ship._() : super._();

  factory _Ship.fromJson(Map<String, dynamic> json) = _$_Ship.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'mmsi')
  int? get mmsi;
  @override
  @JsonKey(name: 'type')
  int get type;
  @override
  @JsonKey(name: 'latitude')
  double get lat;
  @override
  @JsonKey(name: 'longitude')
  double get lon;
  @override
  @JsonKey(name: 'heading')
  double get heading;
  @override
  @JsonKey(ignore: true)
  _$$_ShipCopyWith<_$_Ship> get copyWith => throw _privateConstructorUsedError;
}
