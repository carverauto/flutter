// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chase_animation_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChaseAnimationEvent _$ChaseAnimationEventFromJson(Map<String, dynamic> json) {
  return _ChaseAnimationEvent.fromJson(json);
}

/// @nodoc
class _$ChaseAnimationEventTearOff {
  const _$ChaseAnimationEventTearOff();

  _ChaseAnimationEvent call(
      {required String id,
      @AnimTypeConvertor() required AnimType animtype,
      required String endpoint,
      required String animstate,
      required int label,
      required String videoId,
      required String artboard,
      required List<String> animations,
      @AlignmentConvertor() required Alignment alignment,
      @DatetimeTimestampConverter() required DateTime createdAt}) {
    return _ChaseAnimationEvent(
      id: id,
      animtype: animtype,
      endpoint: endpoint,
      animstate: animstate,
      label: label,
      videoId: videoId,
      artboard: artboard,
      animations: animations,
      alignment: alignment,
      createdAt: createdAt,
    );
  }

  ChaseAnimationEvent fromJson(Map<String, Object?> json) {
    return ChaseAnimationEvent.fromJson(json);
  }
}

/// @nodoc
const $ChaseAnimationEvent = _$ChaseAnimationEventTearOff();

/// @nodoc
mixin _$ChaseAnimationEvent {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id => throw _privateConstructorUsedError;
  @AnimTypeConvertor()
  AnimType get animtype => throw _privateConstructorUsedError;
  String get endpoint => throw _privateConstructorUsedError;
  String get animstate => throw _privateConstructorUsedError;
  int get label => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get artboard => throw _privateConstructorUsedError;
  List<String> get animations => throw _privateConstructorUsedError;
  @AlignmentConvertor()
  Alignment get alignment =>
      throw _privateConstructorUsedError; // required String alignment,
  @DatetimeTimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChaseAnimationEventCopyWith<ChaseAnimationEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChaseAnimationEventCopyWith<$Res> {
  factory $ChaseAnimationEventCopyWith(
          ChaseAnimationEvent value, $Res Function(ChaseAnimationEvent) then) =
      _$ChaseAnimationEventCopyWithImpl<$Res>;
  $Res call(
      {String id,
      @AnimTypeConvertor() AnimType animtype,
      String endpoint,
      String animstate,
      int label,
      String videoId,
      String artboard,
      List<String> animations,
      @AlignmentConvertor() Alignment alignment,
      @DatetimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$ChaseAnimationEventCopyWithImpl<$Res>
    implements $ChaseAnimationEventCopyWith<$Res> {
  _$ChaseAnimationEventCopyWithImpl(this._value, this._then);

  final ChaseAnimationEvent _value;
  // ignore: unused_field
  final $Res Function(ChaseAnimationEvent) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? animtype = freezed,
    Object? endpoint = freezed,
    Object? animstate = freezed,
    Object? label = freezed,
    Object? videoId = freezed,
    Object? artboard = freezed,
    Object? animations = freezed,
    Object? alignment = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      animtype: animtype == freezed
          ? _value.animtype
          : animtype // ignore: cast_nullable_to_non_nullable
              as AnimType,
      endpoint: endpoint == freezed
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      animstate: animstate == freezed
          ? _value.animstate
          : animstate // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as int,
      videoId: videoId == freezed
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      artboard: artboard == freezed
          ? _value.artboard
          : artboard // ignore: cast_nullable_to_non_nullable
              as String,
      animations: animations == freezed
          ? _value.animations
          : animations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      alignment: alignment == freezed
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as Alignment,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$ChaseAnimationEventCopyWith<$Res>
    implements $ChaseAnimationEventCopyWith<$Res> {
  factory _$ChaseAnimationEventCopyWith(_ChaseAnimationEvent value,
          $Res Function(_ChaseAnimationEvent) then) =
      __$ChaseAnimationEventCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      @AnimTypeConvertor() AnimType animtype,
      String endpoint,
      String animstate,
      int label,
      String videoId,
      String artboard,
      List<String> animations,
      @AlignmentConvertor() Alignment alignment,
      @DatetimeTimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$ChaseAnimationEventCopyWithImpl<$Res>
    extends _$ChaseAnimationEventCopyWithImpl<$Res>
    implements _$ChaseAnimationEventCopyWith<$Res> {
  __$ChaseAnimationEventCopyWithImpl(
      _ChaseAnimationEvent _value, $Res Function(_ChaseAnimationEvent) _then)
      : super(_value, (v) => _then(v as _ChaseAnimationEvent));

  @override
  _ChaseAnimationEvent get _value => super._value as _ChaseAnimationEvent;

  @override
  $Res call({
    Object? id = freezed,
    Object? animtype = freezed,
    Object? endpoint = freezed,
    Object? animstate = freezed,
    Object? label = freezed,
    Object? videoId = freezed,
    Object? artboard = freezed,
    Object? animations = freezed,
    Object? alignment = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_ChaseAnimationEvent(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      animtype: animtype == freezed
          ? _value.animtype
          : animtype // ignore: cast_nullable_to_non_nullable
              as AnimType,
      endpoint: endpoint == freezed
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      animstate: animstate == freezed
          ? _value.animstate
          : animstate // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as int,
      videoId: videoId == freezed
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      artboard: artboard == freezed
          ? _value.artboard
          : artboard // ignore: cast_nullable_to_non_nullable
              as String,
      animations: animations == freezed
          ? _value.animations
          : animations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      alignment: alignment == freezed
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as Alignment,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ChaseAnimationEvent extends _ChaseAnimationEvent {
  const _$_ChaseAnimationEvent(
      {required this.id,
      @AnimTypeConvertor() required this.animtype,
      required this.endpoint,
      required this.animstate,
      required this.label,
      required this.videoId,
      required this.artboard,
      required this.animations,
      @AlignmentConvertor() required this.alignment,
      @DatetimeTimestampConverter() required this.createdAt})
      : super._();

  factory _$_ChaseAnimationEvent.fromJson(Map<String, dynamic> json) =>
      _$$_ChaseAnimationEventFromJson(json);

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  final String id;
  @override
  @AnimTypeConvertor()
  final AnimType animtype;
  @override
  final String endpoint;
  @override
  final String animstate;
  @override
  final int label;
  @override
  final String videoId;
  @override
  final String artboard;
  @override
  final List<String> animations;
  @override
  @AlignmentConvertor()
  final Alignment alignment;
  @override // required String alignment,
  @DatetimeTimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChaseAnimationEvent(id: $id, animtype: $animtype, endpoint: $endpoint, animstate: $animstate, label: $label, videoId: $videoId, artboard: $artboard, animations: $animations, alignment: $alignment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChaseAnimationEvent &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.animtype, animtype) &&
            const DeepCollectionEquality().equals(other.endpoint, endpoint) &&
            const DeepCollectionEquality().equals(other.animstate, animstate) &&
            const DeepCollectionEquality().equals(other.label, label) &&
            const DeepCollectionEquality().equals(other.videoId, videoId) &&
            const DeepCollectionEquality().equals(other.artboard, artboard) &&
            const DeepCollectionEquality()
                .equals(other.animations, animations) &&
            const DeepCollectionEquality().equals(other.alignment, alignment) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(animtype),
      const DeepCollectionEquality().hash(endpoint),
      const DeepCollectionEquality().hash(animstate),
      const DeepCollectionEquality().hash(label),
      const DeepCollectionEquality().hash(videoId),
      const DeepCollectionEquality().hash(artboard),
      const DeepCollectionEquality().hash(animations),
      const DeepCollectionEquality().hash(alignment),
      const DeepCollectionEquality().hash(createdAt));

  @JsonKey(ignore: true)
  @override
  _$ChaseAnimationEventCopyWith<_ChaseAnimationEvent> get copyWith =>
      __$ChaseAnimationEventCopyWithImpl<_ChaseAnimationEvent>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChaseAnimationEventToJson(this);
  }
}

abstract class _ChaseAnimationEvent extends ChaseAnimationEvent {
  const factory _ChaseAnimationEvent(
          {required String id,
          @AnimTypeConvertor() required AnimType animtype,
          required String endpoint,
          required String animstate,
          required int label,
          required String videoId,
          required String artboard,
          required List<String> animations,
          @AlignmentConvertor() required Alignment alignment,
          @DatetimeTimestampConverter() required DateTime createdAt}) =
      _$_ChaseAnimationEvent;
  const _ChaseAnimationEvent._() : super._();

  factory _ChaseAnimationEvent.fromJson(Map<String, dynamic> json) =
      _$_ChaseAnimationEvent.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id;
  @override
  @AnimTypeConvertor()
  AnimType get animtype;
  @override
  String get endpoint;
  @override
  String get animstate;
  @override
  int get label;
  @override
  String get videoId;
  @override
  String get artboard;
  @override
  List<String> get animations;
  @override
  @AlignmentConvertor()
  Alignment get alignment;
  @override // required String alignment,
  @DatetimeTimestampConverter()
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$ChaseAnimationEventCopyWith<_ChaseAnimationEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
