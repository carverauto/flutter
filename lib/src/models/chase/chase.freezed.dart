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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Chase _$ChaseFromJson(Map<String, dynamic> json) {
  return _Chase.fromJson(json);
}

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
  Map<String, dynamic>? get wheels => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChaseCopyWith<Chase> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChaseCopyWith<$Res> {
  factory $ChaseCopyWith(Chase value, $Res Function(Chase) then) =
      _$ChaseCopyWithImpl<$Res, Chase>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'Name')
          String? name,
      @JsonKey(name: 'Live')
          bool? live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          DateTime? createdAt,
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
          Map<String, dynamic>? wheels});
}

/// @nodoc
class _$ChaseCopyWithImpl<$Res, $Val extends Chase>
    implements $ChaseCopyWith<$Res> {
  _$ChaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? live = freezed,
    Object? createdAt = freezed,
    Object? desc = freezed,
    Object? imageURL = freezed,
    Object? votes = freezed,
    Object? networks = freezed,
    Object? sentiment = freezed,
    Object? wheels = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      live: freezed == live
          ? _value.live
          : live // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      imageURL: freezed == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int?,
      networks: freezed == networks
          ? _value.networks
          : networks // ignore: cast_nullable_to_non_nullable
              as List<ChaseNetwork>?,
      sentiment: freezed == sentiment
          ? _value.sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
      wheels: freezed == wheels
          ? _value.wheels
          : wheels // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChaseCopyWith<$Res> implements $ChaseCopyWith<$Res> {
  factory _$$_ChaseCopyWith(_$_Chase value, $Res Function(_$_Chase) then) =
      __$$_ChaseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'Name')
          String? name,
      @JsonKey(name: 'Live')
          bool? live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          DateTime? createdAt,
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
          Map<String, dynamic>? wheels});
}

/// @nodoc
class __$$_ChaseCopyWithImpl<$Res> extends _$ChaseCopyWithImpl<$Res, _$_Chase>
    implements _$$_ChaseCopyWith<$Res> {
  __$$_ChaseCopyWithImpl(_$_Chase _value, $Res Function(_$_Chase) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? live = freezed,
    Object? createdAt = freezed,
    Object? desc = freezed,
    Object? imageURL = freezed,
    Object? votes = freezed,
    Object? networks = freezed,
    Object? sentiment = freezed,
    Object? wheels = freezed,
  }) {
    return _then(_$_Chase(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      live: freezed == live
          ? _value.live
          : live // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      imageURL: freezed == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int?,
      networks: freezed == networks
          ? _value._networks
          : networks // ignore: cast_nullable_to_non_nullable
              as List<ChaseNetwork>?,
      sentiment: freezed == sentiment
          ? _value._sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as Map<dynamic, dynamic>?,
      wheels: freezed == wheels
          ? _value._wheels
          : wheels // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      @JsonKey(name: 'Desc')
          required this.desc,
      @JsonKey(name: 'ImageURL')
          this.imageURL,
      @JsonKey(name: 'Votes')
          required this.votes,
      @JsonKey(name: 'Networks')
          final List<ChaseNetwork>? networks,
      @JsonKey(name: 'sentiment')
          final Map<dynamic, dynamic>? sentiment,
      @JsonKey(name: 'Wheels')
          final Map<String, dynamic>? wheels})
      : _networks = networks,
        _sentiment = sentiment,
        _wheels = wheels,
        super._();

  factory _$_Chase.fromJson(Map<String, dynamic> json) =>
      _$$_ChaseFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
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
  @JsonKey(name: 'Desc')
  final String? desc;
  @override
  @JsonKey(name: 'ImageURL')
  final String? imageURL;
  @override
  @JsonKey(name: 'Votes')
  final int? votes;
  final List<ChaseNetwork>? _networks;
  @override
  @JsonKey(name: 'Networks')
  List<ChaseNetwork>? get networks {
    final value = _networks;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<dynamic, dynamic>? _sentiment;
  @override
  @JsonKey(name: 'sentiment')
  Map<dynamic, dynamic>? get sentiment {
    final value = _sentiment;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _wheels;
  @override
  @JsonKey(name: 'Wheels')
  Map<String, dynamic>? get wheels {
    final value = _wheels;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Chase(id: $id, name: $name, live: $live, createdAt: $createdAt, desc: $desc, imageURL: $imageURL, votes: $votes, networks: $networks, sentiment: $sentiment, wheels: $wheels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Chase &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.live, live) || other.live == live) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.imageURL, imageURL) ||
                other.imageURL == imageURL) &&
            (identical(other.votes, votes) || other.votes == votes) &&
            const DeepCollectionEquality().equals(other._networks, _networks) &&
            const DeepCollectionEquality()
                .equals(other._sentiment, _sentiment) &&
            const DeepCollectionEquality().equals(other._wheels, _wheels));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      live,
      createdAt,
      desc,
      imageURL,
      votes,
      const DeepCollectionEquality().hash(_networks),
      const DeepCollectionEquality().hash(_sentiment),
      const DeepCollectionEquality().hash(_wheels));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChaseCopyWith<_$_Chase> get copyWith =>
      __$$_ChaseCopyWithImpl<_$_Chase>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChaseToJson(
      this,
    );
  }
}

abstract class _Chase extends Chase {
  const factory _Chase(
      {required final String id,
      @JsonKey(name: 'Name')
          required final String? name,
      @JsonKey(name: 'Live')
          required final bool? live,
      @JsonKey(name: 'CreatedAt')
      @DatetimeTimestampNullableConverter()
          required final DateTime? createdAt,
      @JsonKey(name: 'Desc')
          required final String? desc,
      @JsonKey(name: 'ImageURL')
          final String? imageURL,
      @JsonKey(name: 'Votes')
          required final int? votes,
      @JsonKey(name: 'Networks')
          final List<ChaseNetwork>? networks,
      @JsonKey(name: 'sentiment')
          final Map<dynamic, dynamic>? sentiment,
      @JsonKey(name: 'Wheels')
          final Map<String, dynamic>? wheels}) = _$_Chase;
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
  Map<String, dynamic>? get wheels;
  @override
  @JsonKey(ignore: true)
  _$$_ChaseCopyWith<_$_Chase> get copyWith =>
      throw _privateConstructorUsedError;
}
