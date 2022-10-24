// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'birds_of_fire.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BirdsOfFire _$BirdsOfFireFromJson(Map<String, dynamic> json) {
  return _BirdsOfFire.fromJson(json);
}

/// @nodoc
mixin _$BirdsOfFire {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @JsonKey(name: 'geometry')
  BOFGeometry get geometry => throw _privateConstructorUsedError;
  @JsonKey(name: 'properties')
  BofProperties get properties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BirdsOfFireCopyWith<BirdsOfFire> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BirdsOfFireCopyWith<$Res> {
  factory $BirdsOfFireCopyWith(
          BirdsOfFire value, $Res Function(BirdsOfFire) then) =
      _$BirdsOfFireCopyWithImpl<$Res, BirdsOfFire>;
  @useResult
  $Res call(
      {@JsonKey(name: 'geometry') BOFGeometry geometry,
      @JsonKey(name: 'properties') BofProperties properties});

  $BOFGeometryCopyWith<$Res> get geometry;
  $BofPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$BirdsOfFireCopyWithImpl<$Res, $Val extends BirdsOfFire>
    implements $BirdsOfFireCopyWith<$Res> {
  _$BirdsOfFireCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geometry = null,
    Object? properties = null,
  }) {
    return _then(_value.copyWith(
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as BOFGeometry,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as BofProperties,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BOFGeometryCopyWith<$Res> get geometry {
    return $BOFGeometryCopyWith<$Res>(_value.geometry, (value) {
      return _then(_value.copyWith(geometry: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BofPropertiesCopyWith<$Res> get properties {
    return $BofPropertiesCopyWith<$Res>(_value.properties, (value) {
      return _then(_value.copyWith(properties: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BirdsOfFireCopyWith<$Res>
    implements $BirdsOfFireCopyWith<$Res> {
  factory _$$_BirdsOfFireCopyWith(
          _$_BirdsOfFire value, $Res Function(_$_BirdsOfFire) then) =
      __$$_BirdsOfFireCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'geometry') BOFGeometry geometry,
      @JsonKey(name: 'properties') BofProperties properties});

  @override
  $BOFGeometryCopyWith<$Res> get geometry;
  @override
  $BofPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_BirdsOfFireCopyWithImpl<$Res>
    extends _$BirdsOfFireCopyWithImpl<$Res, _$_BirdsOfFire>
    implements _$$_BirdsOfFireCopyWith<$Res> {
  __$$_BirdsOfFireCopyWithImpl(
      _$_BirdsOfFire _value, $Res Function(_$_BirdsOfFire) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geometry = null,
    Object? properties = null,
  }) {
    return _then(_$_BirdsOfFire(
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as BOFGeometry,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as BofProperties,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_BirdsOfFire extends _BirdsOfFire {
  const _$_BirdsOfFire(
      {@JsonKey(name: 'geometry') required this.geometry,
      @JsonKey(name: 'properties') required this.properties})
      : super._();

  factory _$_BirdsOfFire.fromJson(Map<String, dynamic> json) =>
      _$$_BirdsOfFireFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @override
  @JsonKey(name: 'geometry')
  final BOFGeometry geometry;
  @override
  @JsonKey(name: 'properties')
  final BofProperties properties;

  @override
  String toString() {
    return 'BirdsOfFire(geometry: $geometry, properties: $properties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BirdsOfFire &&
            (identical(other.geometry, geometry) ||
                other.geometry == geometry) &&
            (identical(other.properties, properties) ||
                other.properties == properties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, geometry, properties);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BirdsOfFireCopyWith<_$_BirdsOfFire> get copyWith =>
      __$$_BirdsOfFireCopyWithImpl<_$_BirdsOfFire>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BirdsOfFireToJson(
      this,
    );
  }
}

abstract class _BirdsOfFire extends BirdsOfFire {
  const factory _BirdsOfFire(
      {@JsonKey(name: 'geometry')
          required final BOFGeometry geometry,
      @JsonKey(name: 'properties')
          required final BofProperties properties}) = _$_BirdsOfFire;
  const _BirdsOfFire._() : super._();

  factory _BirdsOfFire.fromJson(Map<String, dynamic> json) =
      _$_BirdsOfFire.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
// required String id,
  @JsonKey(name: 'geometry')
  BOFGeometry get geometry;
  @override
  @JsonKey(name: 'properties')
  BofProperties get properties;
  @override
  @JsonKey(ignore: true)
  _$$_BirdsOfFireCopyWith<_$_BirdsOfFire> get copyWith =>
      throw _privateConstructorUsedError;
}
