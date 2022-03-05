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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) {
  return _NotificationData.fromJson(json);
}

/// @nodoc
class _$NotificationDataTearOff {
  const _$NotificationDataTearOff();

  _NotificationData call(
      {@JsonKey(name: 'Id') String? id,
      @JsonKey(name: 'Image') String? image,
      @JsonKey(name: 'Tweetid') String? tweetId,
      @JsonKey(name: 'ConfigState') String? configState}) {
    return _NotificationData(
      id: id,
      image: image,
      tweetId: tweetId,
      configState: configState,
    );
  }

  NotificationData fromJson(Map<String, Object?> json) {
    return NotificationData.fromJson(json);
  }
}

/// @nodoc
const $NotificationData = _$NotificationDataTearOff();

/// @nodoc
mixin _$NotificationData {
  @JsonKey(name: 'Id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Image')
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'Tweetid')
  String? get tweetId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConfigState')
  String? get configState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationDataCopyWith<NotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationDataCopyWith<$Res> {
  factory $NotificationDataCopyWith(
          NotificationData value, $Res Function(NotificationData) then) =
      _$NotificationDataCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'Id') String? id,
      @JsonKey(name: 'Image') String? image,
      @JsonKey(name: 'Tweetid') String? tweetId,
      @JsonKey(name: 'ConfigState') String? configState});
}

/// @nodoc
class _$NotificationDataCopyWithImpl<$Res>
    implements $NotificationDataCopyWith<$Res> {
  _$NotificationDataCopyWithImpl(this._value, this._then);

  final NotificationData _value;
  // ignore: unused_field
  final $Res Function(NotificationData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? image = freezed,
    Object? tweetId = freezed,
    Object? configState = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      tweetId: tweetId == freezed
          ? _value.tweetId
          : tweetId // ignore: cast_nullable_to_non_nullable
              as String?,
      configState: configState == freezed
          ? _value.configState
          : configState // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$NotificationDataCopyWith<$Res>
    implements $NotificationDataCopyWith<$Res> {
  factory _$NotificationDataCopyWith(
          _NotificationData value, $Res Function(_NotificationData) then) =
      __$NotificationDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'Id') String? id,
      @JsonKey(name: 'Image') String? image,
      @JsonKey(name: 'Tweetid') String? tweetId,
      @JsonKey(name: 'ConfigState') String? configState});
}

/// @nodoc
class __$NotificationDataCopyWithImpl<$Res>
    extends _$NotificationDataCopyWithImpl<$Res>
    implements _$NotificationDataCopyWith<$Res> {
  __$NotificationDataCopyWithImpl(
      _NotificationData _value, $Res Function(_NotificationData) _then)
      : super(_value, (v) => _then(v as _NotificationData));

  @override
  _NotificationData get _value => super._value as _NotificationData;

  @override
  $Res call({
    Object? id = freezed,
    Object? image = freezed,
    Object? tweetId = freezed,
    Object? configState = freezed,
  }) {
    return _then(_NotificationData(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      tweetId: tweetId == freezed
          ? _value.tweetId
          : tweetId // ignore: cast_nullable_to_non_nullable
              as String?,
      configState: configState == freezed
          ? _value.configState
          : configState // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_NotificationData extends _NotificationData {
  const _$_NotificationData(
      {@JsonKey(name: 'Id') this.id,
      @JsonKey(name: 'Image') this.image,
      @JsonKey(name: 'Tweetid') this.tweetId,
      @JsonKey(name: 'ConfigState') this.configState})
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
  @JsonKey(name: 'Tweetid')
  final String? tweetId;
  @override
  @JsonKey(name: 'ConfigState')
  final String? configState;

  @override
  String toString() {
    return 'NotificationData(id: $id, image: $image, tweetId: $tweetId, configState: $configState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationData &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other.tweetId, tweetId) &&
            const DeepCollectionEquality()
                .equals(other.configState, configState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(tweetId),
      const DeepCollectionEquality().hash(configState));

  @JsonKey(ignore: true)
  @override
  _$NotificationDataCopyWith<_NotificationData> get copyWith =>
      __$NotificationDataCopyWithImpl<_NotificationData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NotificationDataToJson(this);
  }
}

abstract class _NotificationData extends NotificationData {
  const factory _NotificationData(
      {@JsonKey(name: 'Id') String? id,
      @JsonKey(name: 'Image') String? image,
      @JsonKey(name: 'Tweetid') String? tweetId,
      @JsonKey(name: 'ConfigState') String? configState}) = _$_NotificationData;
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
  @JsonKey(name: 'Tweetid')
  String? get tweetId;
  @override
  @JsonKey(name: 'ConfigState')
  String? get configState;
  @override
  @JsonKey(ignore: true)
  _$NotificationDataCopyWith<_NotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}
