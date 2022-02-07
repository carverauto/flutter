// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
      {required String Token,
      required int CreatedAt,
      required Device Device,
      required TokenType TokenType}) {
    return _PushToken(
      Token: Token,
      CreatedAt: CreatedAt,
      Device: Device,
      TokenType: TokenType,
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
  String get Token => throw _privateConstructorUsedError;
  int get CreatedAt => throw _privateConstructorUsedError;
  Device get Device => throw _privateConstructorUsedError;
  TokenType get TokenType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PushTokenCopyWith<PushToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushTokenCopyWith<$Res> {
  factory $PushTokenCopyWith(PushToken value, $Res Function(PushToken) then) =
      _$PushTokenCopyWithImpl<$Res>;
  $Res call({String Token, int CreatedAt, Device Device, TokenType TokenType});
}

/// @nodoc
class _$PushTokenCopyWithImpl<$Res> implements $PushTokenCopyWith<$Res> {
  _$PushTokenCopyWithImpl(this._value, this._then);

  final PushToken _value;
  // ignore: unused_field
  final $Res Function(PushToken) _then;

  @override
  $Res call({
    Object? Token = freezed,
    Object? CreatedAt = freezed,
    Object? Device = freezed,
    Object? TokenType = freezed,
  }) {
    return _then(_value.copyWith(
      Token: Token == freezed
          ? _value.Token
          : Token // ignore: cast_nullable_to_non_nullable
              as String,
      CreatedAt: CreatedAt == freezed
          ? _value.CreatedAt
          : CreatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      Device: Device == freezed
          ? _value.Device
          : Device // ignore: cast_nullable_to_non_nullable
              as Device,
      TokenType: TokenType == freezed
          ? _value.TokenType
          : TokenType // ignore: cast_nullable_to_non_nullable
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
  $Res call({String Token, int CreatedAt, Device Device, TokenType TokenType});
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
    Object? Token = freezed,
    Object? CreatedAt = freezed,
    Object? Device = freezed,
    Object? TokenType = freezed,
  }) {
    return _then(_PushToken(
      Token: Token == freezed
          ? _value.Token
          : Token // ignore: cast_nullable_to_non_nullable
              as String,
      CreatedAt: CreatedAt == freezed
          ? _value.CreatedAt
          : CreatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      Device: Device == freezed
          ? _value.Device
          : Device // ignore: cast_nullable_to_non_nullable
              as Device,
      TokenType: TokenType == freezed
          ? _value.TokenType
          : TokenType // ignore: cast_nullable_to_non_nullable
              as TokenType,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PushToken extends _PushToken {
  const _$_PushToken(
      {required this.Token,
      required this.CreatedAt,
      required this.Device,
      required this.TokenType})
      : super._();

  factory _$_PushToken.fromJson(Map<String, dynamic> json) =>
      _$$_PushTokenFromJson(json);

  @override
  final String Token;
  @override
  final int CreatedAt;
  @override
  final Device Device;
  @override
  final TokenType TokenType;

  @override
  String toString() {
    return 'PushToken(Token: $Token, CreatedAt: $CreatedAt, Device: $Device, TokenType: $TokenType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PushToken &&
            const DeepCollectionEquality().equals(other.Token, Token) &&
            const DeepCollectionEquality().equals(other.CreatedAt, CreatedAt) &&
            const DeepCollectionEquality().equals(other.Device, Device) &&
            const DeepCollectionEquality().equals(other.TokenType, TokenType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(Token),
      const DeepCollectionEquality().hash(CreatedAt),
      const DeepCollectionEquality().hash(Device),
      const DeepCollectionEquality().hash(TokenType));

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
      {required String Token,
      required int CreatedAt,
      required Device Device,
      required TokenType TokenType}) = _$_PushToken;
  const _PushToken._() : super._();

  factory _PushToken.fromJson(Map<String, dynamic> json) =
      _$_PushToken.fromJson;

  @override
  String get Token;
  @override
  int get CreatedAt;
  @override
  Device get Device;
  @override
  TokenType get TokenType;
  @override
  @JsonKey(ignore: true)
  _$PushTokenCopyWith<_PushToken> get copyWith =>
      throw _privateConstructorUsedError;
}
