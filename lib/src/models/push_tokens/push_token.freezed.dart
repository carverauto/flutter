// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'push_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PushToken _$PushTokenFromJson(Map<String, dynamic> json) {
  return _PushToken.fromJson(json);
}

/// @nodoc
class _$PushTokenTearOff {
  const _$PushTokenTearOff();

  _PushToken call(
      {required String token,
      required int created_at,
      required DeviceOS device,
      required TokenType type}) {
    return _PushToken(
      token: token,
      created_at: created_at,
      device: device,
      type: type,
    );
  }

  PushToken fromJson(Map<String, Object?> json) {
    return PushToken.fromJson(json);
  }
}

/// @nodoc
const $PushToken = _$PushTokenTearOff();

/// @nodoc
mixin _$PushToken {
  String get token => throw _privateConstructorUsedError;
  int get created_at => throw _privateConstructorUsedError;
  DeviceOS get device => throw _privateConstructorUsedError;
  TokenType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PushTokenCopyWith<PushToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushTokenCopyWith<$Res> {
  factory $PushTokenCopyWith(PushToken value, $Res Function(PushToken) then) =
      _$PushTokenCopyWithImpl<$Res>;
  $Res call({String token, int created_at, DeviceOS device, TokenType type});
}

/// @nodoc
class _$PushTokenCopyWithImpl<$Res> implements $PushTokenCopyWith<$Res> {
  _$PushTokenCopyWithImpl(this._value, this._then);

  final PushToken _value;
  // ignore: unused_field
  final $Res Function(PushToken) _then;

  @override
  $Res call({
    Object? token = freezed,
    Object? created_at = freezed,
    Object? device = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      token: token == freezed
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: created_at == freezed
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      device: device == freezed
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as DeviceOS,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TokenType,
    ));
  }
}

/// @nodoc
abstract class _$PushTokenCopyWith<$Res> implements $PushTokenCopyWith<$Res> {
  factory _$PushTokenCopyWith(
          _PushToken value, $Res Function(_PushToken) then) =
      __$PushTokenCopyWithImpl<$Res>;
  @override
  $Res call({String token, int created_at, DeviceOS device, TokenType type});
}

/// @nodoc
class __$PushTokenCopyWithImpl<$Res> extends _$PushTokenCopyWithImpl<$Res>
    implements _$PushTokenCopyWith<$Res> {
  __$PushTokenCopyWithImpl(_PushToken _value, $Res Function(_PushToken) _then)
      : super(_value, (v) => _then(v as _PushToken));

  @override
  _PushToken get _value => super._value as _PushToken;

  @override
  $Res call({
    Object? token = freezed,
    Object? created_at = freezed,
    Object? device = freezed,
    Object? type = freezed,
  }) {
    return _then(_PushToken(
      token: token == freezed
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: created_at == freezed
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      device: device == freezed
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as DeviceOS,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TokenType,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PushToken extends _PushToken {
  const _$_PushToken(
      {required this.token,
      required this.created_at,
      required this.device,
      required this.type})
      : super._();

  factory _$_PushToken.fromJson(Map<String, dynamic> json) =>
      _$$_PushTokenFromJson(json);

  @override
  final String token;
  @override
  final int created_at;
  @override
  final DeviceOS device;
  @override
  final TokenType type;

  @override
  String toString() {
    return 'PushToken(token: $token, created_at: $created_at, device: $device, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PushToken &&
            const DeepCollectionEquality().equals(other.token, token) &&
            const DeepCollectionEquality()
                .equals(other.created_at, created_at) &&
            const DeepCollectionEquality().equals(other.device, device) &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(token),
      const DeepCollectionEquality().hash(created_at),
      const DeepCollectionEquality().hash(device),
      const DeepCollectionEquality().hash(type));

  @JsonKey(ignore: true)
  @override
  _$PushTokenCopyWith<_PushToken> get copyWith =>
      __$PushTokenCopyWithImpl<_PushToken>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PushTokenToJson(this);
  }
}

abstract class _PushToken extends PushToken {
  const factory _PushToken(
      {required String token,
      required int created_at,
      required DeviceOS device,
      required TokenType type}) = _$_PushToken;
  const _PushToken._() : super._();

  factory _PushToken.fromJson(Map<String, dynamic> json) =
      _$_PushToken.fromJson;

  @override
  String get token;
  @override
  int get created_at;
  @override
  DeviceOS get device;
  @override
  TokenType get type;
  @override
  @JsonKey(ignore: true)
  _$PushTokenCopyWith<_PushToken> get copyWith =>
      throw _privateConstructorUsedError;
}
