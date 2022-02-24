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
      {required String typeId,
      required String id,
      String? title,
      String? body,
      @DatetimeTimestampConverter() required DateTime createdAt,
      Map<String, dynamic>? data}) {
    return _NotificationData(
      typeId: typeId,
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      data: data,
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
  String get typeId => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  @DatetimeTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

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
      {String typeId,
      String id,
      String? title,
      String? body,
      @DatetimeTimestampConverter() DateTime createdAt,
      Map<String, dynamic>? data});
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
    Object? typeId = freezed,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? createdAt = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      typeId: typeId == freezed
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      {String typeId,
      String id,
      String? title,
      String? body,
      @DatetimeTimestampConverter() DateTime createdAt,
      Map<String, dynamic>? data});
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
    Object? typeId = freezed,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? createdAt = freezed,
    Object? data = freezed,
  }) {
    return _then(_NotificationData(
      typeId: typeId == freezed
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as String,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_NotificationData extends _NotificationData {
  const _$_NotificationData(
      {required this.typeId,
      required this.id,
      this.title,
      this.body,
      @DatetimeTimestampConverter() required this.createdAt,
      this.data})
      : super._();

  factory _$_NotificationData.fromJson(Map<String, dynamic> json) =>
      _$$_NotificationDataFromJson(json);

  @override
  final String typeId;
  @override
  final String id;
  @override
  final String? title;
  @override
  final String? body;
  @override
  @DatetimeTimestampConverter()
  final DateTime createdAt;
  @override
  final Map<String, dynamic>? data;

  @override
  String toString() {
    return 'NotificationData(typeId: $typeId, id: $id, title: $title, body: $body, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationData &&
            const DeepCollectionEquality().equals(other.typeId, typeId) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.body, body) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(typeId),
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(body),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(data));

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
      {required String typeId,
      required String id,
      String? title,
      String? body,
      @DatetimeTimestampConverter() required DateTime createdAt,
      Map<String, dynamic>? data}) = _$_NotificationData;
  const _NotificationData._() : super._();

  factory _NotificationData.fromJson(Map<String, dynamic> json) =
      _$_NotificationData.fromJson;

  @override
  String get typeId;
  @override
  String get id;
  @override
  String? get title;
  @override
  String? get body;
  @override
  @DatetimeTimestampConverter()
  DateTime get createdAt;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(ignore: true)
  _$NotificationDataCopyWith<_NotificationData> get copyWith =>
      throw _privateConstructorUsedError;
}
