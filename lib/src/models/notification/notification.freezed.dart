// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChaseAppNotification _$ChaseAppNotificationFromJson(Map<String, dynamic> json) {
  return _ChaseAppNotification.fromJson(json);
}

/// @nodoc
class _$ChaseAppNotificationTearOff {
  const _$ChaseAppNotificationTearOff();

  _ChaseAppNotification call(
      {@JsonKey(name: 'Interest')
          required String interest,
      String? id,
      @JsonKey(name: 'Type')
          required String type,
      @JsonKey(name: 'Title')
          required String title,
      @JsonKey(name: 'Body')
          required String body,
      @JsonKey(name: 'Image')
          String? image,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          required DateTime createdAt,
      @JsonKey(name: 'Data')
          NotificationData? data}) {
    return _ChaseAppNotification(
      interest: interest,
      id: id,
      type: type,
      title: title,
      body: body,
      image: image,
      createdAt: createdAt,
      data: data,
    );
  }

  ChaseAppNotification fromJson(Map<String, Object?> json) {
    return ChaseAppNotification.fromJson(json);
  }
}

/// @nodoc
const $ChaseAppNotification = _$ChaseAppNotificationTearOff();

/// @nodoc
mixin _$ChaseAppNotification {
  @JsonKey(name: 'Interest')
  String get interest => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Type')
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Body')
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'Image')
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'Data')
  NotificationData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChaseAppNotificationCopyWith<ChaseAppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChaseAppNotificationCopyWith<$Res> {
  factory $ChaseAppNotificationCopyWith(ChaseAppNotification value,
          $Res Function(ChaseAppNotification) then) =
      _$ChaseAppNotificationCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'Interest')
          String interest,
      String? id,
      @JsonKey(name: 'Type')
          String type,
      @JsonKey(name: 'Title')
          String title,
      @JsonKey(name: 'Body')
          String body,
      @JsonKey(name: 'Image')
          String? image,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          DateTime createdAt,
      @JsonKey(name: 'Data')
          NotificationData? data});

  $NotificationDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$ChaseAppNotificationCopyWithImpl<$Res>
    implements $ChaseAppNotificationCopyWith<$Res> {
  _$ChaseAppNotificationCopyWithImpl(this._value, this._then);

  final ChaseAppNotification _value;
  // ignore: unused_field
  final $Res Function(ChaseAppNotification) _then;

  @override
  $Res call({
    Object? interest = freezed,
    Object? id = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? image = freezed,
    Object? createdAt = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      interest: interest == freezed
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NotificationData?,
    ));
  }

  @override
  $NotificationDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $NotificationDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
abstract class _$ChaseAppNotificationCopyWith<$Res>
    implements $ChaseAppNotificationCopyWith<$Res> {
  factory _$ChaseAppNotificationCopyWith(_ChaseAppNotification value,
          $Res Function(_ChaseAppNotification) then) =
      __$ChaseAppNotificationCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'Interest')
          String interest,
      String? id,
      @JsonKey(name: 'Type')
          String type,
      @JsonKey(name: 'Title')
          String title,
      @JsonKey(name: 'Body')
          String body,
      @JsonKey(name: 'Image')
          String? image,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          DateTime createdAt,
      @JsonKey(name: 'Data')
          NotificationData? data});

  @override
  $NotificationDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$ChaseAppNotificationCopyWithImpl<$Res>
    extends _$ChaseAppNotificationCopyWithImpl<$Res>
    implements _$ChaseAppNotificationCopyWith<$Res> {
  __$ChaseAppNotificationCopyWithImpl(
      _ChaseAppNotification _value, $Res Function(_ChaseAppNotification) _then)
      : super(_value, (v) => _then(v as _ChaseAppNotification));

  @override
  _ChaseAppNotification get _value => super._value as _ChaseAppNotification;

  @override
  $Res call({
    Object? interest = freezed,
    Object? id = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? image = freezed,
    Object? createdAt = freezed,
    Object? data = freezed,
  }) {
    return _then(_ChaseAppNotification(
      interest: interest == freezed
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NotificationData?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ChaseAppNotification extends _ChaseAppNotification {
  const _$_ChaseAppNotification(
      {@JsonKey(name: 'Interest')
          required this.interest,
      this.id,
      @JsonKey(name: 'Type')
          required this.type,
      @JsonKey(name: 'Title')
          required this.title,
      @JsonKey(name: 'Body')
          required this.body,
      @JsonKey(name: 'Image')
          this.image,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          required this.createdAt,
      @JsonKey(name: 'Data')
          this.data})
      : super._();

  factory _$_ChaseAppNotification.fromJson(Map<String, dynamic> json) =>
      _$$_ChaseAppNotificationFromJson(json);

  @override
  @JsonKey(name: 'Interest')
  final String interest;
  @override
  final String? id;
  @override
  @JsonKey(name: 'Type')
  final String type;
  @override
  @JsonKey(name: 'Title')
  final String title;
  @override
  @JsonKey(name: 'Body')
  final String body;
  @override
  @JsonKey(name: 'Image')
  final String? image;
  @override
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampConverter()
  final DateTime createdAt;
  @override
  @JsonKey(name: 'Data')
  final NotificationData? data;

  @override
  String toString() {
    return 'ChaseAppNotification(interest: $interest, id: $id, type: $type, title: $title, body: $body, image: $image, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChaseAppNotification &&
            const DeepCollectionEquality().equals(other.interest, interest) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.body, body) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(interest),
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(body),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$ChaseAppNotificationCopyWith<_ChaseAppNotification> get copyWith =>
      __$ChaseAppNotificationCopyWithImpl<_ChaseAppNotification>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChaseAppNotificationToJson(this);
  }
}

abstract class _ChaseAppNotification extends ChaseAppNotification {
  const factory _ChaseAppNotification(
      {@JsonKey(name: 'Interest')
          required String interest,
      String? id,
      @JsonKey(name: 'Type')
          required String type,
      @JsonKey(name: 'Title')
          required String title,
      @JsonKey(name: 'Body')
          required String body,
      @JsonKey(name: 'Image')
          String? image,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          required DateTime createdAt,
      @JsonKey(name: 'Data')
          NotificationData? data}) = _$_ChaseAppNotification;
  const _ChaseAppNotification._() : super._();

  factory _ChaseAppNotification.fromJson(Map<String, dynamic> json) =
      _$_ChaseAppNotification.fromJson;

  @override
  @JsonKey(name: 'Interest')
  String get interest;
  @override
  String? get id;
  @override
  @JsonKey(name: 'Type')
  String get type;
  @override
  @JsonKey(name: 'Title')
  String get title;
  @override
  @JsonKey(name: 'Body')
  String get body;
  @override
  @JsonKey(name: 'Image')
  String? get image;
  @override
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampConverter()
  DateTime get createdAt;
  @override
  @JsonKey(name: 'Data')
  NotificationData? get data;
  @override
  @JsonKey(ignore: true)
  _$ChaseAppNotificationCopyWith<_ChaseAppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}
