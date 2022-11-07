// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tfr_properties.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TFRProperties _$TFRPropertiesFromJson(Map<String, dynamic> json) {
  return _TFRProperties.fromJson(json);
}

/// @nodoc
mixin _$TFRProperties {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'radiusArc')
  int get radiusArc => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TFRPropertiesCopyWith<TFRProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TFRPropertiesCopyWith<$Res> {
  factory $TFRPropertiesCopyWith(
          TFRProperties value, $Res Function(TFRProperties) then) =
      _$TFRPropertiesCopyWithImpl<$Res, TFRProperties>;
  @useResult
  $Res call(
      {@JsonKey(name: 'radiusArc') int radiusArc,
      @JsonKey(name: 'id') String id});
}

/// @nodoc
class _$TFRPropertiesCopyWithImpl<$Res, $Val extends TFRProperties>
    implements $TFRPropertiesCopyWith<$Res> {
  _$TFRPropertiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? radiusArc = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      radiusArc: null == radiusArc
          ? _value.radiusArc
          : radiusArc // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TFRPropertiesCopyWith<$Res>
    implements $TFRPropertiesCopyWith<$Res> {
  factory _$$_TFRPropertiesCopyWith(
          _$_TFRProperties value, $Res Function(_$_TFRProperties) then) =
      __$$_TFRPropertiesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'radiusArc') int radiusArc,
      @JsonKey(name: 'id') String id});
}

/// @nodoc
class __$$_TFRPropertiesCopyWithImpl<$Res>
    extends _$TFRPropertiesCopyWithImpl<$Res, _$_TFRProperties>
    implements _$$_TFRPropertiesCopyWith<$Res> {
  __$$_TFRPropertiesCopyWithImpl(
      _$_TFRProperties _value, $Res Function(_$_TFRProperties) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? radiusArc = null,
    Object? id = null,
  }) {
    return _then(_$_TFRProperties(
      radiusArc: null == radiusArc
          ? _value.radiusArc
          : radiusArc // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_TFRProperties extends _TFRProperties {
  const _$_TFRProperties(
      {@JsonKey(name: 'radiusArc') required this.radiusArc,
      @JsonKey(name: 'id') required this.id})
      : super._();

  factory _$_TFRProperties.fromJson(Map<String, dynamic> json) =>
      _$$_TFRPropertiesFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  @JsonKey(name: 'radiusArc')
  final int radiusArc;
  @override
  @JsonKey(name: 'id')
  final String id;

  @override
  String toString() {
    return 'TFRProperties(radiusArc: $radiusArc, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TFRProperties &&
            (identical(other.radiusArc, radiusArc) ||
                other.radiusArc == radiusArc) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, radiusArc, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TFRPropertiesCopyWith<_$_TFRProperties> get copyWith =>
      __$$_TFRPropertiesCopyWithImpl<_$_TFRProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TFRPropertiesToJson(
      this,
    );
  }
}

abstract class _TFRProperties extends TFRProperties {
  const factory _TFRProperties(
      {@JsonKey(name: 'radiusArc') required final int radiusArc,
      @JsonKey(name: 'id') required final String id}) = _$_TFRProperties;
  const _TFRProperties._() : super._();

  factory _TFRProperties.fromJson(Map<String, dynamic> json) =
      _$_TFRProperties.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'radiusArc')
  int get radiusArc;
  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$_TFRPropertiesCopyWith<_$_TFRProperties> get copyWith =>
      throw _privateConstructorUsedError;
}
