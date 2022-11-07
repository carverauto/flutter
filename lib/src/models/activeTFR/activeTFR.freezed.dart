// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'activeTFR.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActiveTFR _$ActiveTFRFromJson(Map<String, dynamic> json) {
  return _ActiveTFR.fromJson(json);
}

/// @nodoc
mixin _$ActiveTFR {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'geometry')
  BOFGeometry get geometry => throw _privateConstructorUsedError;
  @JsonKey(name: 'properties')
  TFRProperties get properties => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActiveTFRCopyWith<ActiveTFR> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveTFRCopyWith<$Res> {
  factory $ActiveTFRCopyWith(ActiveTFR value, $Res Function(ActiveTFR) then) =
      _$ActiveTFRCopyWithImpl<$Res, ActiveTFR>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'geometry') BOFGeometry geometry,
      @JsonKey(name: 'properties') TFRProperties properties});

  $BOFGeometryCopyWith<$Res> get geometry;
  $TFRPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class _$ActiveTFRCopyWithImpl<$Res, $Val extends ActiveTFR>
    implements $ActiveTFRCopyWith<$Res> {
  _$ActiveTFRCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? geometry = null,
    Object? properties = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as BOFGeometry,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as TFRProperties,
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
  $TFRPropertiesCopyWith<$Res> get properties {
    return $TFRPropertiesCopyWith<$Res>(_value.properties, (value) {
      return _then(_value.copyWith(properties: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ActiveTFRCopyWith<$Res> implements $ActiveTFRCopyWith<$Res> {
  factory _$$_ActiveTFRCopyWith(
          _$_ActiveTFR value, $Res Function(_$_ActiveTFR) then) =
      __$$_ActiveTFRCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'geometry') BOFGeometry geometry,
      @JsonKey(name: 'properties') TFRProperties properties});

  @override
  $BOFGeometryCopyWith<$Res> get geometry;
  @override
  $TFRPropertiesCopyWith<$Res> get properties;
}

/// @nodoc
class __$$_ActiveTFRCopyWithImpl<$Res>
    extends _$ActiveTFRCopyWithImpl<$Res, _$_ActiveTFR>
    implements _$$_ActiveTFRCopyWith<$Res> {
  __$$_ActiveTFRCopyWithImpl(
      _$_ActiveTFR _value, $Res Function(_$_ActiveTFR) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? geometry = null,
    Object? properties = null,
  }) {
    return _then(_$_ActiveTFR(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as BOFGeometry,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as TFRProperties,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ActiveTFR extends _ActiveTFR {
  const _$_ActiveTFR(
      {required this.id,
      @JsonKey(name: 'geometry') required this.geometry,
      @JsonKey(name: 'properties') required this.properties})
      : super._();

  factory _$_ActiveTFR.fromJson(Map<String, dynamic> json) =>
      _$$_ActiveTFRFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  final String id;
  @override
  @JsonKey(name: 'geometry')
  final BOFGeometry geometry;
  @override
  @JsonKey(name: 'properties')
  final TFRProperties properties;

  @override
  String toString() {
    return 'ActiveTFR(id: $id, geometry: $geometry, properties: $properties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActiveTFR &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.geometry, geometry) ||
                other.geometry == geometry) &&
            (identical(other.properties, properties) ||
                other.properties == properties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, geometry, properties);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActiveTFRCopyWith<_$_ActiveTFR> get copyWith =>
      __$$_ActiveTFRCopyWithImpl<_$_ActiveTFR>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActiveTFRToJson(
      this,
    );
  }
}

abstract class _ActiveTFR extends ActiveTFR {
  const factory _ActiveTFR(
      {required final String id,
      @JsonKey(name: 'geometry')
          required final BOFGeometry geometry,
      @JsonKey(name: 'properties')
          required final TFRProperties properties}) = _$_ActiveTFR;
  const _ActiveTFR._() : super._();

  factory _ActiveTFR.fromJson(Map<String, dynamic> json) =
      _$_ActiveTFR.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id;
  @override
  @JsonKey(name: 'geometry')
  BOFGeometry get geometry;
  @override
  @JsonKey(name: 'properties')
  TFRProperties get properties;
  @override
  @JsonKey(ignore: true)
  _$$_ActiveTFRCopyWith<_$_ActiveTFR> get copyWith =>
      throw _privateConstructorUsedError;
}
