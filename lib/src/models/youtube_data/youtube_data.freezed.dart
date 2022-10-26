// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'youtube_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

YoutubeData _$YoutubeDataFromJson(Map<String, dynamic> json) {
  return _YoutubeData.fromJson(json);
}

/// @nodoc
mixin _$YoutubeData {
  String get videoId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get channelId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  int get subcribersCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $YoutubeDataCopyWith<YoutubeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YoutubeDataCopyWith<$Res> {
  factory $YoutubeDataCopyWith(
          YoutubeData value, $Res Function(YoutubeData) then) =
      _$YoutubeDataCopyWithImpl<$Res, YoutubeData>;
  @useResult
  $Res call(
      {String videoId,
      String text,
      String channelId,
      String userName,
      String name,
      String profileImageUrl,
      int subcribersCount});
}

/// @nodoc
class _$YoutubeDataCopyWithImpl<$Res, $Val extends YoutubeData>
    implements $YoutubeDataCopyWith<$Res> {
  _$YoutubeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? text = null,
    Object? channelId = null,
    Object? userName = null,
    Object? name = null,
    Object? profileImageUrl = null,
    Object? subcribersCount = null,
  }) {
    return _then(_value.copyWith(
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      subcribersCount: null == subcribersCount
          ? _value.subcribersCount
          : subcribersCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_YoutubeDataCopyWith<$Res>
    implements $YoutubeDataCopyWith<$Res> {
  factory _$$_YoutubeDataCopyWith(
          _$_YoutubeData value, $Res Function(_$_YoutubeData) then) =
      __$$_YoutubeDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String videoId,
      String text,
      String channelId,
      String userName,
      String name,
      String profileImageUrl,
      int subcribersCount});
}

/// @nodoc
class __$$_YoutubeDataCopyWithImpl<$Res>
    extends _$YoutubeDataCopyWithImpl<$Res, _$_YoutubeData>
    implements _$$_YoutubeDataCopyWith<$Res> {
  __$$_YoutubeDataCopyWithImpl(
      _$_YoutubeData _value, $Res Function(_$_YoutubeData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? text = null,
    Object? channelId = null,
    Object? userName = null,
    Object? name = null,
    Object? profileImageUrl = null,
    Object? subcribersCount = null,
  }) {
    return _then(_$_YoutubeData(
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      subcribersCount: null == subcribersCount
          ? _value.subcribersCount
          : subcribersCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_YoutubeData extends _YoutubeData {
  const _$_YoutubeData(
      {required this.videoId,
      required this.text,
      required this.channelId,
      required this.userName,
      required this.name,
      required this.profileImageUrl,
      required this.subcribersCount})
      : super._();

  factory _$_YoutubeData.fromJson(Map<String, dynamic> json) =>
      _$$_YoutubeDataFromJson(json);

  @override
  final String videoId;
  @override
  final String text;
  @override
  final String channelId;
  @override
  final String userName;
  @override
  final String name;
  @override
  final String profileImageUrl;
  @override
  final int subcribersCount;

  @override
  String toString() {
    return 'YoutubeData(videoId: $videoId, text: $text, channelId: $channelId, userName: $userName, name: $name, profileImageUrl: $profileImageUrl, subcribersCount: $subcribersCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_YoutubeData &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.subcribersCount, subcribersCount) ||
                other.subcribersCount == subcribersCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, videoId, text, channelId,
      userName, name, profileImageUrl, subcribersCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_YoutubeDataCopyWith<_$_YoutubeData> get copyWith =>
      __$$_YoutubeDataCopyWithImpl<_$_YoutubeData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_YoutubeDataToJson(
      this,
    );
  }
}

abstract class _YoutubeData extends YoutubeData {
  const factory _YoutubeData(
      {required final String videoId,
      required final String text,
      required final String channelId,
      required final String userName,
      required final String name,
      required final String profileImageUrl,
      required final int subcribersCount}) = _$_YoutubeData;
  const _YoutubeData._() : super._();

  factory _YoutubeData.fromJson(Map<String, dynamic> json) =
      _$_YoutubeData.fromJson;

  @override
  String get videoId;
  @override
  String get text;
  @override
  String get channelId;
  @override
  String get userName;
  @override
  String get name;
  @override
  String get profileImageUrl;
  @override
  int get subcribersCount;
  @override
  @JsonKey(ignore: true)
  _$$_YoutubeDataCopyWith<_$_YoutubeData> get copyWith =>
      throw _privateConstructorUsedError;
}
