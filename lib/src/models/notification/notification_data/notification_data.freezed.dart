// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'notification_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) {
  return _NotificationData.fromJson(json);
}

/// @nodoc
mixin _$NotificationData {
  @JsonKey(name: 'Id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Image')
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'YoutubeId')
  String? get youtubeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ChannelId')
  String? get channelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConfigState')
  String? get configState => throw _privateConstructorUsedError;
  TweetData? get tweetData => throw _privateConstructorUsedError;
  YoutubeData? get youtubeData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationDataCopyWith<NotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationDataCopyWith<$Res> {
  factory $NotificationDataCopyWith(
          NotificationData value, $Res Function(NotificationData) then) =
      _$NotificationDataCopyWithImpl<$Res, NotificationData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'Id') String? id,
      @JsonKey(name: 'Image') String? image,
      @JsonKey(name: 'YoutubeId') String? youtubeId,
      @JsonKey(name: 'ChannelId') String? channelId,
      @JsonKey(name: 'ConfigState') String? configState,
      TweetData? tweetData,
      YoutubeData? youtubeData});

  $TweetDataCopyWith<$Res>? get tweetData;
  $YoutubeDataCopyWith<$Res>? get youtubeData;
}

/// @nodoc
class _$NotificationDataCopyWithImpl<$Res, $Val extends NotificationData>
    implements $NotificationDataCopyWith<$Res> {
  _$NotificationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? image = freezed,
    Object? youtubeId = freezed,
    Object? channelId = freezed,
    Object? configState = freezed,
    Object? tweetData = freezed,
    Object? youtubeData = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeId: freezed == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String?,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      configState: freezed == configState
          ? _value.configState
          : configState // ignore: cast_nullable_to_non_nullable
              as String?,
      tweetData: freezed == tweetData
          ? _value.tweetData
          : tweetData // ignore: cast_nullable_to_non_nullable
              as TweetData?,
      youtubeData: freezed == youtubeData
          ? _value.youtubeData
          : youtubeData // ignore: cast_nullable_to_non_nullable
              as YoutubeData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TweetDataCopyWith<$Res>? get tweetData {
    if (_value.tweetData == null) {
      return null;
    }

    return $TweetDataCopyWith<$Res>(_value.tweetData!, (value) {
      return _then(_value.copyWith(tweetData: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $YoutubeDataCopyWith<$Res>? get youtubeData {
    if (_value.youtubeData == null) {
      return null;
    }

    return $YoutubeDataCopyWith<$Res>(_value.youtubeData!, (value) {
      return _then(_value.copyWith(youtubeData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_NotificationDataCopyWith<$Res>
    implements $NotificationDataCopyWith<$Res> {
  factory _$$_NotificationDataCopyWith(
          _$_NotificationData value, $Res Function(_$_NotificationData) then) =
      __$$_NotificationDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Id') String? id,
      @JsonKey(name: 'Image') String? image,
      @JsonKey(name: 'YoutubeId') String? youtubeId,
      @JsonKey(name: 'ChannelId') String? channelId,
      @JsonKey(name: 'ConfigState') String? configState,
      TweetData? tweetData,
      YoutubeData? youtubeData});

  @override
  $TweetDataCopyWith<$Res>? get tweetData;
  @override
  $YoutubeDataCopyWith<$Res>? get youtubeData;
}

/// @nodoc
class __$$_NotificationDataCopyWithImpl<$Res>
    extends _$NotificationDataCopyWithImpl<$Res, _$_NotificationData>
    implements _$$_NotificationDataCopyWith<$Res> {
  __$$_NotificationDataCopyWithImpl(
      _$_NotificationData _value, $Res Function(_$_NotificationData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? image = freezed,
    Object? youtubeId = freezed,
    Object? channelId = freezed,
    Object? configState = freezed,
    Object? tweetData = freezed,
    Object? youtubeData = freezed,
  }) {
    return _then(_$_NotificationData(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeId: freezed == youtubeId
          ? _value.youtubeId
          : youtubeId // ignore: cast_nullable_to_non_nullable
              as String?,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      configState: freezed == configState
          ? _value.configState
          : configState // ignore: cast_nullable_to_non_nullable
              as String?,
      tweetData: freezed == tweetData
          ? _value.tweetData
          : tweetData // ignore: cast_nullable_to_non_nullable
              as TweetData?,
      youtubeData: freezed == youtubeData
          ? _value.youtubeData
          : youtubeData // ignore: cast_nullable_to_non_nullable
              as YoutubeData?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_NotificationData extends _NotificationData {
  const _$_NotificationData(
      {@JsonKey(name: 'Id') this.id,
      @JsonKey(name: 'Image') this.image,
      @JsonKey(name: 'YoutubeId') this.youtubeId,
      @JsonKey(name: 'ChannelId') this.channelId,
      @JsonKey(name: 'ConfigState') this.configState,
      this.tweetData,
      this.youtubeData})
      : super._();

  factory _$_NotificationData.fromJson(Map<String, dynamic> json) =>
      _$$_NotificationDataFromJson(json);

  @override
  @JsonKey(name: 'Id')
  final String? id;
  @override
  @JsonKey(name: 'Image')
  final String? image;
  @override
  @JsonKey(name: 'YoutubeId')
  final String? youtubeId;
  @override
  @JsonKey(name: 'ChannelId')
  final String? channelId;
  @override
  @JsonKey(name: 'ConfigState')
  final String? configState;
  @override
  final TweetData? tweetData;
  @override
  final YoutubeData? youtubeData;

  @override
  String toString() {
    return 'NotificationData(id: $id, image: $image, youtubeId: $youtubeId, channelId: $channelId, configState: $configState, tweetData: $tweetData, youtubeData: $youtubeData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.youtubeId, youtubeId) ||
                other.youtubeId == youtubeId) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.configState, configState) ||
                other.configState == configState) &&
            (identical(other.tweetData, tweetData) ||
                other.tweetData == tweetData) &&
            (identical(other.youtubeData, youtubeData) ||
                other.youtubeData == youtubeData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, image, youtubeId, channelId,
      configState, tweetData, youtubeData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotificationDataCopyWith<_$_NotificationData> get copyWith =>
      __$$_NotificationDataCopyWithImpl<_$_NotificationData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NotificationDataToJson(
      this,
    );
  }
}

abstract class _NotificationData extends NotificationData {
  const factory _NotificationData(
      {@JsonKey(name: 'Id') final String? id,
      @JsonKey(name: 'Image') final String? image,
      @JsonKey(name: 'YoutubeId') final String? youtubeId,
      @JsonKey(name: 'ChannelId') final String? channelId,
      @JsonKey(name: 'ConfigState') final String? configState,
      final TweetData? tweetData,
      final YoutubeData? youtubeData}) = _$_NotificationData;
  const _NotificationData._() : super._();

  factory _NotificationData.fromJson(Map<String, dynamic> json) =
      _$_NotificationData.fromJson;

  @override
  @JsonKey(name: 'Id')
  String? get id;
  @override
  @JsonKey(name: 'Image')
  String? get image;
  @override
  @JsonKey(name: 'YoutubeId')
  String? get youtubeId;
  @override
  @JsonKey(name: 'ChannelId')
  String? get channelId;
  @override
  @JsonKey(name: 'ConfigState')
  String? get configState;
  @override
  TweetData? get tweetData;
  @override
  YoutubeData? get youtubeData;
  @override
  @JsonKey(ignore: true)
  _$$_NotificationDataCopyWith<_$_NotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}
