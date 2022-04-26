// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Chase _$ChaseFromJson(Map<String, dynamic> json) {
  return _Chase.fromJson(json);
}

/// @nodoc
class _$ChaseTearOff {
  const _$ChaseTearOff();

  _Chase call(
      {required String id,
      @JsonKey(name: 'Name')
          required String? name,
      @JsonKey(name: 'Live')
          required bool? live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          required DateTime? createdAt,
      @JsonKey(name: 'EndedAt')
      @DatetimeTimestampNullableConverter()
          required DateTime? endedAt,
      @JsonKey(name: 'Desc')
          required String? desc,
      @JsonKey(name: 'ImageURL')
          String? imageURL,
      @JsonKey(name: 'Votes')
          required int? votes,
      @JsonKey(name: 'Networks')
          List<ChaseNetwork>? networks,
      @JsonKey(name: 'sentiment')
          Map<dynamic, dynamic>? sentiment,
      @JsonKey(name: 'Wheels')
          Map<dynamic, dynamic>? wheels}) {
    return _Chase(
      id: id,
      name: name,
      live: live,
      createdAt: createdAt,
      endedAt: endedAt,
      desc: desc,
      imageURL: imageURL,
      votes: votes,
      networks: networks,
      sentiment: sentiment,
      wheels: wheels,
    );
  }

  Chase fromJson(Map<String, Object?> json) {
    return Chase.fromJson(json);
  }
}

/// @nodoc
const $Chase = _$ChaseTearOff();

/// @nodoc
mixin _$Chase {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Live')
  bool? get live => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampNullableConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'EndedAt')
  @DatetimeTimestampNullableConverter()
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'Desc')
  String? get desc => throw _privateConstructorUsedError;
  @JsonKey(name: 'ImageURL')
  String? get imageURL => throw _privateConstructorUsedError;
  @JsonKey(name: 'Votes')
  int? get votes => throw _privateConstructorUsedError;
  @JsonKey(name: 'Networks')
  List<ChaseNetwork>? get networks => throw _privateConstructorUsedError;
  @JsonKey(name: 'sentiment')
  Map<dynamic, dynamic>? get sentiment => throw _privateConstructorUsedError;
  @JsonKey(name: 'Wheels')
  Map<dynamic, dynamic>? get wheels => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChaseCopyWith<Chase> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChaseCopyWith<$Res> {
  factory $ChaseCopyWith(Chase value, $Res Function(Chase) then) =
      _$ChaseCopyWithImpl<$Res>;
  $Res call(
      {String id,
      @JsonKey(name: 'Name')
          String? name,
      @JsonKey(name: 'Live')
          bool? live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          DateTime? createdAt,
      @JsonKey(name: 'EndedAt')
      @DatetimeTimestampNullableConverter()
          DateTime? endedAt,
      @JsonKey(name: 'Desc')
          String? desc,
      @JsonKey(name: 'ImageURL')
          String? imageURL,
      @JsonKey(name: 'Votes')
          int? votes,
      @JsonKey(name: 'Networks')
          List<ChaseNetwork>? networks,
      @JsonKey(name: 'sentiment')
          Map<dynamic, dynamic>? sentiment,
      @JsonKey(name: 'Wheels')
          Map<dynamic, dynamic>? wheels});
}

/// @nodoc
class _$ChaseCopyWithImpl<$Res> implements $ChaseCopyWith<$Res> {
  _$ChaseCopyWithImpl(this._value, this._then);

  final Chase _value;
  // ignore: unused_field
  final $Res Function(Chase) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? live = freezed,
    Object? createdAt = freezed,
    Object? endedAt = freezed,
    Object? desc = freezed,
    Object? imageURL = freezed,
    Object? votes = freezed,
    Object? networks = freezed,
    Object? sentiment = freezed,
    Object? wheels = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      live: live == freezed
          ? _value.live
          : live // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: endedAt == freezed
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      desc: desc == freezed
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: votes == freezed
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int?,
      networks: networks == freezed
          ? _value.networks
          : networks // ignore: cast_nullable_to_non_nullable
              as List<ChaseNetwork>?,
      sentiment: sentiment == freezed
          ? _value.sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
      wheels: wheels == freezed
          ? _value.wheels
          : wheels // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
    ));
  }
}

/// @nodoc
abstract class _$ChaseCopyWith<$Res> implements $ChaseCopyWith<$Res> {
  factory _$ChaseCopyWith(_Chase value, $Res Function(_Chase) then) =
      __$ChaseCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      @JsonKey(name: 'Name')
          String? name,
      @JsonKey(name: 'Live')
          bool? live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          DateTime? createdAt,
      @JsonKey(name: 'EndedAt')
      @DatetimeTimestampNullableConverter()
          DateTime? endedAt,
      @JsonKey(name: 'Desc')
          String? desc,
      @JsonKey(name: 'ImageURL')
          String? imageURL,
      @JsonKey(name: 'Votes')
          int? votes,
      @JsonKey(name: 'Networks')
          List<ChaseNetwork>? networks,
      @JsonKey(name: 'sentiment')
          Map<dynamic, dynamic>? sentiment,
      @JsonKey(name: 'Wheels')
          Map<dynamic, dynamic>? wheels});
}

/// @nodoc
class __$ChaseCopyWithImpl<$Res> extends _$ChaseCopyWithImpl<$Res>
    implements _$ChaseCopyWith<$Res> {
  __$ChaseCopyWithImpl(_Chase _value, $Res Function(_Chase) _then)
      : super(_value, (v) => _then(v as _Chase));

  @override
  _Chase get _value => super._value as _Chase;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? live = freezed,
    Object? createdAt = freezed,
    Object? endedAt = freezed,
    Object? desc = freezed,
    Object? imageURL = freezed,
    Object? votes = freezed,
    Object? networks = freezed,
    Object? sentiment = freezed,
    Object? wheels = freezed,
  }) {
    return _then(_Chase(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      live: live == freezed
          ? _value.live
          : live // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: endedAt == freezed
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      desc: desc == freezed
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: votes == freezed
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int?,
      networks: networks == freezed
          ? _value.networks
          : networks // ignore: cast_nullable_to_non_nullable
              as List<ChaseNetwork>?,
      sentiment: sentiment == freezed
          ? _value.sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
      wheels: wheels == freezed
          ? _value.wheels
          : wheels // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Chase extends _Chase {
  const _$_Chase(
      {required this.id,
      @JsonKey(name: 'Name')
          required this.name,
      @JsonKey(name: 'Live')
          required this.live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          required this.createdAt,
      @JsonKey(name: 'EndedAt')
      @DatetimeTimestampNullableConverter()
          required this.endedAt,
      @JsonKey(name: 'Desc')
          required this.desc,
      @JsonKey(name: 'ImageURL')
          this.imageURL,
      @JsonKey(name: 'Votes')
          required this.votes,
      @JsonKey(name: 'Networks')
          this.networks,
      @JsonKey(name: 'sentiment')
          this.sentiment,
      @JsonKey(name: 'Wheels')
          this.wheels})
      : super._();

  factory _$_Chase.fromJson(Map<String, dynamic> json) =>
      _$$_ChaseFromJson(json);

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  final String id;
  @override
  @JsonKey(name: 'Name')
  final String? name;
  @override
  @JsonKey(name: 'Live')
  final bool? live;
  @override
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampNullableConverter()
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'EndedAt')
  @DatetimeTimestampNullableConverter()
  final DateTime? endedAt;
  @override
  @JsonKey(name: 'Desc')
  final String? desc;
  @override
  @JsonKey(name: 'ImageURL')
  final String? imageURL;
  @override
  @JsonKey(name: 'Votes')
  final int? votes;
  @override
  @JsonKey(name: 'Networks')
  final List<ChaseNetwork>? networks;
  @override
  @JsonKey(name: 'sentiment')
  final Map<dynamic, dynamic>? sentiment;
  @override
  @JsonKey(name: 'Wheels')
  final Map<dynamic, dynamic>? wheels;

  @override
  String toString() {
    return 'Chase(id: $id, name: $name, live: $live, createdAt: $createdAt, endedAt: $endedAt, desc: $desc, imageURL: $imageURL, votes: $votes, networks: $networks, sentiment: $sentiment, wheels: $wheels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Chase &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.live, live) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.endedAt, endedAt) &&
            const DeepCollectionEquality().equals(other.desc, desc) &&
            const DeepCollectionEquality().equals(other.imageURL, imageURL) &&
            const DeepCollectionEquality().equals(other.votes, votes) &&
            const DeepCollectionEquality().equals(other.networks, networks) &&
            const DeepCollectionEquality().equals(other.sentiment, sentiment) &&
            const DeepCollectionEquality().equals(other.wheels, wheels));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(live),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(endedAt),
      const DeepCollectionEquality().hash(desc),
      const DeepCollectionEquality().hash(imageURL),
      const DeepCollectionEquality().hash(votes),
      const DeepCollectionEquality().hash(networks),
      const DeepCollectionEquality().hash(sentiment),
      const DeepCollectionEquality().hash(wheels));

  @JsonKey(ignore: true)
  @override
  _$ChaseCopyWith<_Chase> get copyWith =>
      __$ChaseCopyWithImpl<_Chase>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChaseToJson(this);
  }
}

abstract class _Chase extends Chase {
  const factory _Chase(
      {required String id,
      @JsonKey(name: 'Name')
          required String? name,
      @JsonKey(name: 'Live')
          required bool? live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          required DateTime? createdAt,
      @JsonKey(name: 'EndedAt')
      @DatetimeTimestampNullableConverter()
          required DateTime? endedAt,
      @JsonKey(name: 'Desc')
          required String? desc,
      @JsonKey(name: 'ImageURL')
          String? imageURL,
      @JsonKey(name: 'Votes')
          required int? votes,
      @JsonKey(name: 'Networks')
          List<ChaseNetwork>? networks,
      @JsonKey(name: 'sentiment')
          Map<dynamic, dynamic>? sentiment,
      @JsonKey(name: 'Wheels')
          Map<dynamic, dynamic>? wheels}) = _$_Chase;
  const _Chase._() : super._();

  factory _Chase.fromJson(Map<String, dynamic> json) = _$_Chase.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  String get id;
  @override
  @JsonKey(name: 'Name')
  String? get name;
  @override
  @JsonKey(name: 'Live')
  bool? get live;
  @override
  @JsonKey(name: 'CreatedAt')
  @DatetimeTimestampNullableConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'EndedAt')
  @DatetimeTimestampNullableConverter()
  DateTime? get endedAt;
  @override
  @JsonKey(name: 'Desc')
  String? get desc;
  @override
  @JsonKey(name: 'ImageURL')
  String? get imageURL;
  @override
  @JsonKey(name: 'Votes')
  int? get votes;
  @override
  @JsonKey(name: 'Networks')
  List<ChaseNetwork>? get networks;
  @override
  @JsonKey(name: 'sentiment')
  Map<dynamic, dynamic>? get sentiment;
  @override
  @JsonKey(name: 'Wheels')
  Map<dynamic, dynamic>? get wheels;
  @override
  @JsonKey(ignore: true)
  _$ChaseCopyWith<_Chase> get copyWith => throw _privateConstructorUsedError;
}
