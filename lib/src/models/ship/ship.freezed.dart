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
// required String id,
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'mmsi')
  int get mmsi => throw _privateConstructorUsedError;
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
      _$ShipCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'mmsi') int mmsi,
      @JsonKey(name: 'type') int type,
      @JsonKey(name: 'latitude') double lat,
      @JsonKey(name: 'longitude') double lon,
      @JsonKey(name: 'heading') double heading});
}

/// @nodoc
class _$ShipCopyWithImpl<$Res> implements $ShipCopyWith<$Res> {
  _$ShipCopyWithImpl(this._value, this._then);

  final Ship _value;
  // ignore: unused_field
  final $Res Function(Ship) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? mmsi = freezed,
    Object? type = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? heading = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mmsi: mmsi == freezed
          ? _value.mmsi
          : mmsi // ignore: cast_nullable_to_non_nullable
              as int,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      heading: heading == freezed
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_ShipCopyWith<$Res> implements $ShipCopyWith<$Res> {
  factory _$$_ShipCopyWith(_$_Ship value, $Res Function(_$_Ship) then) =
      __$$_ShipCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'mmsi') int mmsi,
      @JsonKey(name: 'type') int type,
      @JsonKey(name: 'latitude') double lat,
      @JsonKey(name: 'longitude') double lon,
      @JsonKey(name: 'heading') double heading});
}

/// @nodoc
class __$$_ShipCopyWithImpl<$Res> extends _$ShipCopyWithImpl<$Res>
    implements _$$_ShipCopyWith<$Res> {
  __$$_ShipCopyWithImpl(_$_Ship _value, $Res Function(_$_Ship) _then)
      : super(_value, (v) => _then(v as _$_Ship));

  @override
  _$_Ship get _value => super._value as _$_Ship;

  @override
  $Res call({
    Object? name = freezed,
    Object? mmsi = freezed,
    Object? type = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? heading = freezed,
  }) {
    return _then(_$_Ship(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mmsi: mmsi == freezed
          ? _value.mmsi
          : mmsi // ignore: cast_nullable_to_non_nullable
              as int,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double,
      heading: heading == freezed
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
      {@JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'mmsi') required this.mmsi,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'latitude') required this.lat,
      @JsonKey(name: 'longitude') required this.lon,
      @JsonKey(name: 'heading') required this.heading})
      : super._();

  factory _$_Ship.fromJson(Map<String, dynamic> json) => _$$_ShipFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'mmsi')
  final int mmsi;
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
    return 'Ship(name: $name, mmsi: $mmsi, type: $type, lat: $lat, lon: $lon, heading: $heading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Ship &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.mmsi, mmsi) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.lat, lat) &&
            const DeepCollectionEquality().equals(other.lon, lon) &&
            const DeepCollectionEquality().equals(other.heading, heading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(mmsi),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(lat),
      const DeepCollectionEquality().hash(lon),
      const DeepCollectionEquality().hash(heading));

  @JsonKey(ignore: true)
  @override
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
      {@JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'mmsi') required final int mmsi,
      @JsonKey(name: 'type') required final int type,
      @JsonKey(name: 'latitude') required final double lat,
      @JsonKey(name: 'longitude') required final double lon,
      @JsonKey(name: 'heading') required final double heading}) = _$_Ship;
  const _Ship._() : super._();

  factory _Ship.fromJson(Map<String, dynamic> json) = _$_Ship.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'mmsi')
  int get mmsi;
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
