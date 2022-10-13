// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tweet_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TweetData _$TweetDataFromJson(Map<String, dynamic> json) {
  return _TweetData.fromJson(json);
}

/// @nodoc
mixin _$TweetData {
  String get tweetId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TweetDataCopyWith<TweetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TweetDataCopyWith<$Res> {
  factory $TweetDataCopyWith(TweetData value, $Res Function(TweetData) then) =
      _$TweetDataCopyWithImpl<$Res>;
  $Res call(
      {String tweetId,
      String text,
      String userId,
      String userName,
      String name,
      String profileImageUrl});
}

/// @nodoc
class _$TweetDataCopyWithImpl<$Res> implements $TweetDataCopyWith<$Res> {
  _$TweetDataCopyWithImpl(this._value, this._then);

  final TweetData _value;
  // ignore: unused_field
  final $Res Function(TweetData) _then;

  @override
  $Res call({
    Object? tweetId = freezed,
    Object? text = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? name = freezed,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      tweetId: tweetId == freezed
          ? _value.tweetId
          : tweetId // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: profileImageUrl == freezed
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_TweetDataCopyWith<$Res> implements $TweetDataCopyWith<$Res> {
  factory _$$_TweetDataCopyWith(
          _$_TweetData value, $Res Function(_$_TweetData) then) =
      __$$_TweetDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String tweetId,
      String text,
      String userId,
      String userName,
      String name,
      String profileImageUrl});
}

/// @nodoc
class __$$_TweetDataCopyWithImpl<$Res> extends _$TweetDataCopyWithImpl<$Res>
    implements _$$_TweetDataCopyWith<$Res> {
  __$$_TweetDataCopyWithImpl(
      _$_TweetData _value, $Res Function(_$_TweetData) _then)
      : super(_value, (v) => _then(v as _$_TweetData));

  @override
  _$_TweetData get _value => super._value as _$_TweetData;

  @override
  $Res call({
    Object? tweetId = freezed,
    Object? text = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? name = freezed,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_$_TweetData(
      tweetId: tweetId == freezed
          ? _value.tweetId
          : tweetId // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: profileImageUrl == freezed
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_TweetData extends _TweetData {
  const _$_TweetData(
      {required this.tweetId,
      required this.text,
      required this.userId,
      required this.userName,
      required this.name,
      required this.profileImageUrl})
      : super._();

  factory _$_TweetData.fromJson(Map<String, dynamic> json) =>
      _$$_TweetDataFromJson(json);

  @override
  final String tweetId;
  @override
  final String text;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String name;
  @override
  final String profileImageUrl;

  @override
  String toString() {
    return 'TweetData(tweetId: $tweetId, text: $text, userId: $userId, userName: $userName, name: $name, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TweetData &&
            const DeepCollectionEquality().equals(other.tweetId, tweetId) &&
            const DeepCollectionEquality().equals(other.text, text) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            const DeepCollectionEquality().equals(other.userName, userName) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.profileImageUrl, profileImageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(tweetId),
      const DeepCollectionEquality().hash(text),
      const DeepCollectionEquality().hash(userId),
      const DeepCollectionEquality().hash(userName),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(profileImageUrl));

  @JsonKey(ignore: true)
  @override
  _$$_TweetDataCopyWith<_$_TweetData> get copyWith =>
      __$$_TweetDataCopyWithImpl<_$_TweetData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TweetDataToJson(
      this,
    );
  }
}

abstract class _TweetData extends TweetData {
  const factory _TweetData(
      {required final String tweetId,
      required final String text,
      required final String userId,
      required final String userName,
      required final String name,
      required final String profileImageUrl}) = _$_TweetData;
  const _TweetData._() : super._();

  factory _TweetData.fromJson(Map<String, dynamic> json) =
      _$_TweetData.fromJson;

  @override
  String get tweetId;
  @override
  String get text;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get name;
  @override
  String get profileImageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_TweetDataCopyWith<_$_TweetData> get copyWith =>
      throw _privateConstructorUsedError;
}
