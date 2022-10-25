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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PushToken _$PushTokenFromJson(Map<String, dynamic> json) {
  return _PushToken.fromJson(json);
}

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
      _$PushTokenCopyWithImpl<$Res, PushToken>;
  @useResult
  $Res call({String token, int created_at, DeviceOS device, TokenType type});
}

/// @nodoc
class _$PushTokenCopyWithImpl<$Res, $Val extends PushToken>
    implements $PushTokenCopyWith<$Res> {
  _$PushTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? created_at = null,
    Object? device = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as DeviceOS,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TokenType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PushTokenCopyWith<$Res> implements $PushTokenCopyWith<$Res> {
  factory _$$_PushTokenCopyWith(
          _$_PushToken value, $Res Function(_$_PushToken) then) =
      __$$_PushTokenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, int created_at, DeviceOS device, TokenType type});
}

/// @nodoc
class __$$_PushTokenCopyWithImpl<$Res>
    extends _$PushTokenCopyWithImpl<$Res, _$_PushToken>
    implements _$$_PushTokenCopyWith<$Res> {
  __$$_PushTokenCopyWithImpl(
      _$_PushToken _value, $Res Function(_$_PushToken) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? created_at = null,
    Object? device = null,
    Object? type = null,
  }) {
    return _then(_$_PushToken(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as int,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as DeviceOS,
      type: null == type
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
            other is _$_PushToken &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, created_at, device, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PushTokenCopyWith<_$_PushToken> get copyWith =>
      __$$_PushTokenCopyWithImpl<_$_PushToken>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PushTokenToJson(
      this,
    );
  }
}

abstract class _PushToken extends PushToken {
  const factory _PushToken(
      {required final String token,
      required final int created_at,
      required final DeviceOS device,
      required final TokenType type}) = _$_PushToken;
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
  _$$_PushTokenCopyWith<_$_PushToken> get copyWith =>
      throw _privateConstructorUsedError;
}
