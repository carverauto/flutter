// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'interest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Interest _$InterestFromJson(Map<String, dynamic> json) {
  return _Interest.fromJson(json);
}

/// @nodoc
mixin _$Interest {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id => throw _privateConstructorUsedError;
  String get instanceId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isCompulsory => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  @DatetimeTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InterestCopyWith<Interest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestCopyWith<$Res> {
  factory $InterestCopyWith(Interest value, $Res Function(Interest) then) =
      _$InterestCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String instanceId,
      String name,
      bool isCompulsory,
      bool isDefault,
      @DatetimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$InterestCopyWithImpl<$Res> implements $InterestCopyWith<$Res> {
  _$InterestCopyWithImpl(this._value, this._then);

  final Interest _value;
  // ignore: unused_field
  final $Res Function(Interest) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? instanceId = freezed,
    Object? name = freezed,
    Object? isCompulsory = freezed,
    Object? isDefault = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      instanceId: instanceId == freezed
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isCompulsory: isCompulsory == freezed
          ? _value.isCompulsory
          : isCompulsory // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: isDefault == freezed
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$$_InterestCopyWith<$Res> implements $InterestCopyWith<$Res> {
  factory _$$_InterestCopyWith(
          _$_Interest value, $Res Function(_$_Interest) then) =
      __$$_InterestCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String instanceId,
      String name,
      bool isCompulsory,
      bool isDefault,
      @DatetimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$$_InterestCopyWithImpl<$Res> extends _$InterestCopyWithImpl<$Res>
    implements _$$_InterestCopyWith<$Res> {
  __$$_InterestCopyWithImpl(
      _$_Interest _value, $Res Function(_$_Interest) _then)
      : super(_value, (v) => _then(v as _$_Interest));

  @override
  _$_Interest get _value => super._value as _$_Interest;

  @override
  $Res call({
    Object? id = freezed,
    Object? instanceId = freezed,
    Object? name = freezed,
    Object? isCompulsory = freezed,
    Object? isDefault = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$_Interest(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      instanceId: instanceId == freezed
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isCompulsory: isCompulsory == freezed
          ? _value.isCompulsory
          : isCompulsory // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: isDefault == freezed
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Interest extends _Interest {
  const _$_Interest(
      {required this.id,
      required this.instanceId,
      required this.name,
      required this.isCompulsory,
      required this.isDefault,
      @DatetimeTimestampConverter() required this.createdAt})
      : super._();

  factory _$_Interest.fromJson(Map<String, dynamic> json) =>
      _$$_InterestFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  final String id;
  @override
  final String instanceId;
  @override
  final String name;
  @override
  final bool isCompulsory;
  @override
  final bool isDefault;
  @override
  @DatetimeTimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'Interest(id: $id, instanceId: $instanceId, name: $name, isCompulsory: $isCompulsory, isDefault: $isDefault, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Interest &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.instanceId, instanceId) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.isCompulsory, isCompulsory) &&
            const DeepCollectionEquality().equals(other.isDefault, isDefault) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(instanceId),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(isCompulsory),
      const DeepCollectionEquality().hash(isDefault),
      const DeepCollectionEquality().hash(createdAt));

  @JsonKey(ignore: true)
  @override
  _$$_InterestCopyWith<_$_Interest> get copyWith =>
      __$$_InterestCopyWithImpl<_$_Interest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_InterestToJson(
      this,
    );
  }
}

abstract class _Interest extends Interest {
  const factory _Interest(
          {required final String id,
          required final String instanceId,
          required final String name,
          required final bool isCompulsory,
          required final bool isDefault,
          @DatetimeTimestampConverter() required final DateTime createdAt}) =
      _$_Interest;
  const _Interest._() : super._();

  factory _Interest.fromJson(Map<String, dynamic> json) = _$_Interest.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id;
  @override
  String get instanceId;
  @override
  String get name;
  @override
  bool get isCompulsory;
  @override
  bool get isDefault;
  @override
  @DatetimeTimestampConverter()
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_InterestCopyWith<_$_Interest> get copyWith =>
      throw _privateConstructorUsedError;
}
