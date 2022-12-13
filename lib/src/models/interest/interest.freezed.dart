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
  bool get isPremium => throw _privateConstructorUsedError;
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
      _$InterestCopyWithImpl<$Res, Interest>;
  @useResult
  $Res call(
      {String id,
      String instanceId,
      String name,
      bool isCompulsory,
      bool isDefault,
      bool isPremium,
      @DatetimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$InterestCopyWithImpl<$Res, $Val extends Interest>
    implements $InterestCopyWith<$Res> {
  _$InterestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? instanceId = null,
    Object? name = null,
    Object? isCompulsory = null,
    Object? isDefault = null,
    Object? isPremium = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isCompulsory: null == isCompulsory
          ? _value.isCompulsory
          : isCompulsory // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InterestCopyWith<$Res> implements $InterestCopyWith<$Res> {
  factory _$$_InterestCopyWith(
          _$_Interest value, $Res Function(_$_Interest) then) =
      __$$_InterestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String instanceId,
      String name,
      bool isCompulsory,
      bool isDefault,
      bool isPremium,
      @DatetimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$$_InterestCopyWithImpl<$Res>
    extends _$InterestCopyWithImpl<$Res, _$_Interest>
    implements _$$_InterestCopyWith<$Res> {
  __$$_InterestCopyWithImpl(
      _$_Interest _value, $Res Function(_$_Interest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? instanceId = null,
    Object? name = null,
    Object? isCompulsory = null,
    Object? isDefault = null,
    Object? isPremium = null,
    Object? createdAt = null,
  }) {
    return _then(_$_Interest(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isCompulsory: null == isCompulsory
          ? _value.isCompulsory
          : isCompulsory // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
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
      required this.isPremium,
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
  final bool isPremium;
  @override
  @DatetimeTimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'Interest(id: $id, instanceId: $instanceId, name: $name, isCompulsory: $isCompulsory, isDefault: $isDefault, isPremium: $isPremium, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Interest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isCompulsory, isCompulsory) ||
                other.isCompulsory == isCompulsory) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, instanceId, name,
      isCompulsory, isDefault, isPremium, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
          required final bool isPremium,
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
  bool get isPremium;
  @override
  @DatetimeTimestampConverter()
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_InterestCopyWith<_$_Interest> get copyWith =>
      throw _privateConstructorUsedError;
}
