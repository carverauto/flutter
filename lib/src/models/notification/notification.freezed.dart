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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChaseAppNotification _$ChaseAppNotificationFromJson(Map<String, dynamic> json) {
  return _ChaseAppNotification.fromJson(json);
}

/// @nodoc
mixin _$ChaseAppNotification {
  @JsonKey(name: 'Interest')
  String get interest => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Type')
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Body')
  String get body =>
      throw _privateConstructorUsedError; // @JsonKey(name: 'Image') String? image,
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
      _$ChaseAppNotificationCopyWithImpl<$Res, ChaseAppNotification>;
  @useResult
  $Res call(
      {@JsonKey(name: 'Interest')
          String interest,
      String id,
      @JsonKey(name: 'Type')
          String type,
      @JsonKey(name: 'Title')
          String title,
      @JsonKey(name: 'Body')
          String body,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          DateTime createdAt,
      @JsonKey(name: 'Data')
          NotificationData? data});

  $NotificationDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$ChaseAppNotificationCopyWithImpl<$Res,
        $Val extends ChaseAppNotification>
    implements $ChaseAppNotificationCopyWith<$Res> {
  _$ChaseAppNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interest = null,
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      interest: null == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as NotificationData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $NotificationDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ChaseAppNotificationCopyWith<$Res>
    implements $ChaseAppNotificationCopyWith<$Res> {
  factory _$$_ChaseAppNotificationCopyWith(_$_ChaseAppNotification value,
          $Res Function(_$_ChaseAppNotification) then) =
      __$$_ChaseAppNotificationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Interest')
          String interest,
      String id,
      @JsonKey(name: 'Type')
          String type,
      @JsonKey(name: 'Title')
          String title,
      @JsonKey(name: 'Body')
          String body,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          DateTime createdAt,
      @JsonKey(name: 'Data')
          NotificationData? data});

  @override
  $NotificationDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$_ChaseAppNotificationCopyWithImpl<$Res>
    extends _$ChaseAppNotificationCopyWithImpl<$Res, _$_ChaseAppNotification>
    implements _$$_ChaseAppNotificationCopyWith<$Res> {
  __$$_ChaseAppNotificationCopyWithImpl(_$_ChaseAppNotification _value,
      $Res Function(_$_ChaseAppNotification) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interest = null,
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_$_ChaseAppNotification(
      interest: null == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: freezed == data
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
      required this.id,
      @JsonKey(name: 'Type')
          required this.type,
      @JsonKey(name: 'Title')
          required this.title,
      @JsonKey(name: 'Body')
          required this.body,
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
  final String id;
  @override
  @JsonKey(name: 'Type')
  final String type;
  @override
  @JsonKey(name: 'Title')
  final String title;
  @override
  @JsonKey(name: 'Body')
  final String body;
// @JsonKey(name: 'Image') String? image,
  @override
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampConverter()
  final DateTime createdAt;
  @override
  @JsonKey(name: 'Data')
  final NotificationData? data;

  @override
  String toString() {
    return 'ChaseAppNotification(interest: $interest, id: $id, type: $type, title: $title, body: $body, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChaseAppNotification &&
            (identical(other.interest, interest) ||
                other.interest == interest) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, interest, id, type, title, body, createdAt, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChaseAppNotificationCopyWith<_$_ChaseAppNotification> get copyWith =>
      __$$_ChaseAppNotificationCopyWithImpl<_$_ChaseAppNotification>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChaseAppNotificationToJson(
      this,
    );
  }
}

abstract class _ChaseAppNotification extends ChaseAppNotification {
  const factory _ChaseAppNotification(
      {@JsonKey(name: 'Interest')
          required final String interest,
      required final String id,
      @JsonKey(name: 'Type')
          required final String type,
      @JsonKey(name: 'Title')
          required final String title,
      @JsonKey(name: 'Body')
          required final String body,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampConverter()
          required final DateTime createdAt,
      @JsonKey(name: 'Data')
          final NotificationData? data}) = _$_ChaseAppNotification;
  const _ChaseAppNotification._() : super._();

  factory _ChaseAppNotification.fromJson(Map<String, dynamic> json) =
      _$_ChaseAppNotification.fromJson;

  @override
  @JsonKey(name: 'Interest')
  String get interest;
  @override
  String get id;
  @override
  @JsonKey(name: 'Type')
  String get type;
  @override
  @JsonKey(name: 'Title')
  String get title;
  @override
  @JsonKey(name: 'Body')
  String get body;
  @override // @JsonKey(name: 'Image') String? image,
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampConverter()
  DateTime get createdAt;
  @override
  @JsonKey(name: 'Data')
  NotificationData? get data;
  @override
  @JsonKey(ignore: true)
  _$$_ChaseAppNotificationCopyWith<_$_ChaseAppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}
