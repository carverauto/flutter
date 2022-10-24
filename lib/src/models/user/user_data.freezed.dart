// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get uid => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get photoURL => throw _privateConstructorUsedError;
  int get lastUpdated => throw _privateConstructorUsedError;
  @DatetimeTimestampNullableConverter()
  DateTime? get lastTokenUpdate => throw _privateConstructorUsedError;
  List<PushToken>? get tokens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String uid,
      String? userName,
      String? email,
      String? photoURL,
      int lastUpdated,
      @DatetimeTimestampNullableConverter() DateTime? lastTokenUpdate,
      List<PushToken>? tokens});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? userName = freezed,
    Object? email = freezed,
    Object? photoURL = freezed,
    Object? lastUpdated = null,
    Object? lastTokenUpdate = freezed,
    Object? tokens = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as int,
      lastTokenUpdate: freezed == lastTokenUpdate
          ? _value.lastTokenUpdate
          : lastTokenUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tokens: freezed == tokens
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<PushToken>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserDataCopyWith<$Res> implements $UserDataCopyWith<$Res> {
  factory _$$_UserDataCopyWith(
          _$_UserData value, $Res Function(_$_UserData) then) =
      __$$_UserDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String? userName,
      String? email,
      String? photoURL,
      int lastUpdated,
      @DatetimeTimestampNullableConverter() DateTime? lastTokenUpdate,
      List<PushToken>? tokens});
}

/// @nodoc
class __$$_UserDataCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$_UserData>
    implements _$$_UserDataCopyWith<$Res> {
  __$$_UserDataCopyWithImpl(
      _$_UserData _value, $Res Function(_$_UserData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? userName = freezed,
    Object? email = freezed,
    Object? photoURL = freezed,
    Object? lastUpdated = null,
    Object? lastTokenUpdate = freezed,
    Object? tokens = freezed,
  }) {
    return _then(_$_UserData(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as int,
      lastTokenUpdate: freezed == lastTokenUpdate
          ? _value.lastTokenUpdate
          : lastTokenUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tokens: freezed == tokens
          ? _value._tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<PushToken>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_UserData extends _UserData {
  const _$_UserData(
      {required this.uid,
      this.userName,
      this.email,
      this.photoURL,
      required this.lastUpdated,
      @DatetimeTimestampNullableConverter() this.lastTokenUpdate,
      final List<PushToken>? tokens})
      : _tokens = tokens,
        super._();

  factory _$_UserData.fromJson(Map<String, dynamic> json) =>
      _$$_UserDataFromJson(json);

  @override
  final String uid;
  @override
  final String? userName;
  @override
  final String? email;
  @override
  final String? photoURL;
  @override
  final int lastUpdated;
  @override
  @DatetimeTimestampNullableConverter()
  final DateTime? lastTokenUpdate;
  final List<PushToken>? _tokens;
  @override
  List<PushToken>? get tokens {
    final value = _tokens;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserData(uid: $uid, userName: $userName, email: $email, photoURL: $photoURL, lastUpdated: $lastUpdated, lastTokenUpdate: $lastTokenUpdate, tokens: $tokens)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserData &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.lastTokenUpdate, lastTokenUpdate) ||
                other.lastTokenUpdate == lastTokenUpdate) &&
            const DeepCollectionEquality().equals(other._tokens, _tokens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      userName,
      email,
      photoURL,
      lastUpdated,
      lastTokenUpdate,
      const DeepCollectionEquality().hash(_tokens));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserDataCopyWith<_$_UserData> get copyWith =>
      __$$_UserDataCopyWithImpl<_$_UserData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserDataToJson(
      this,
    );
  }
}

abstract class _UserData extends UserData {
  const factory _UserData(
      {required final String uid,
      final String? userName,
      final String? email,
      final String? photoURL,
      required final int lastUpdated,
      @DatetimeTimestampNullableConverter() final DateTime? lastTokenUpdate,
      final List<PushToken>? tokens}) = _$_UserData;
  const _UserData._() : super._();

  factory _UserData.fromJson(Map<String, dynamic> json) = _$_UserData.fromJson;

  @override
  String get uid;
  @override
  String? get userName;
  @override
  String? get email;
  @override
  String? get photoURL;
  @override
  int get lastUpdated;
  @override
  @DatetimeTimestampNullableConverter()
  DateTime? get lastTokenUpdate;
  @override
  List<PushToken>? get tokens;
  @override
  @JsonKey(ignore: true)
  _$$_UserDataCopyWith<_$_UserData> get copyWith =>
      throw _privateConstructorUsedError;
}
