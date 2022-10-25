// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'geometry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BOFGeometry _$BOFGeometryFromJson(Map<String, dynamic> json) {
  return _BOFGeometry.fromJson(json);
}

/// @nodoc
mixin _$BOFGeometry {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'coordinates')
  List<double> get coordinates => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BOFGeometryCopyWith<BOFGeometry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BOFGeometryCopyWith<$Res> {
  factory $BOFGeometryCopyWith(
          BOFGeometry value, $Res Function(BOFGeometry) then) =
      _$BOFGeometryCopyWithImpl<$Res, BOFGeometry>;
  @useResult
  $Res call(
      {@JsonKey(name: 'coordinates') List<double> coordinates,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class _$BOFGeometryCopyWithImpl<$Res, $Val extends BOFGeometry>
    implements $BOFGeometryCopyWith<$Res> {
  _$BOFGeometryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BOFGeometryCopyWith<$Res>
    implements $BOFGeometryCopyWith<$Res> {
  factory _$$_BOFGeometryCopyWith(
          _$_BOFGeometry value, $Res Function(_$_BOFGeometry) then) =
      __$$_BOFGeometryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'coordinates') List<double> coordinates,
      @JsonKey(name: 'type') String type});
}

/// @nodoc
class __$$_BOFGeometryCopyWithImpl<$Res>
    extends _$BOFGeometryCopyWithImpl<$Res, _$_BOFGeometry>
    implements _$$_BOFGeometryCopyWith<$Res> {
  __$$_BOFGeometryCopyWithImpl(
      _$_BOFGeometry _value, $Res Function(_$_BOFGeometry) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinates = null,
    Object? type = null,
  }) {
    return _then(_$_BOFGeometry(
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_BOFGeometry extends _BOFGeometry {
  const _$_BOFGeometry(
      {@JsonKey(name: 'coordinates') required final List<double> coordinates,
      @JsonKey(name: 'type') required this.type})
      : _coordinates = coordinates,
        super._();

  factory _$_BOFGeometry.fromJson(Map<String, dynamic> json) =>
      _$$_BOFGeometryFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  final List<double> _coordinates;
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  @JsonKey(name: 'coordinates')
  List<double> get coordinates {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  @JsonKey(name: 'type')
  final String type;

  @override
  String toString() {
    return 'BOFGeometry(coordinates: $coordinates, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BOFGeometry &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_coordinates), type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BOFGeometryCopyWith<_$_BOFGeometry> get copyWith =>
      __$$_BOFGeometryCopyWithImpl<_$_BOFGeometry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BOFGeometryToJson(
      this,
    );
  }
}

abstract class _BOFGeometry extends BOFGeometry {
  const factory _BOFGeometry(
      {@JsonKey(name: 'coordinates') required final List<double> coordinates,
      @JsonKey(name: 'type') required final String type}) = _$_BOFGeometry;
  const _BOFGeometry._() : super._();

  factory _BOFGeometry.fromJson(Map<String, dynamic> json) =
      _$_BOFGeometry.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'coordinates')
  List<double> get coordinates;
  @override
  @JsonKey(name: 'type')
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$_BOFGeometryCopyWith<_$_BOFGeometry> get copyWith =>
      throw _privateConstructorUsedError;
}
