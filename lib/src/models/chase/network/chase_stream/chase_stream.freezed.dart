// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chase_stream.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChaseStream _$ChaseStreamFromJson(Map<String, dynamic> json) {
  return _ChaseStream.fromJson(json);
}

/// @nodoc
mixin _$ChaseStream {
  @JsonKey(name: 'Tier')
  int get tier => throw _privateConstructorUsedError;
  @JsonKey(name: 'URL')
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChaseStreamCopyWith<ChaseStream> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChaseStreamCopyWith<$Res> {
  factory $ChaseStreamCopyWith(
          ChaseStream value, $Res Function(ChaseStream) then) =
      _$ChaseStreamCopyWithImpl<$Res, ChaseStream>;
  @useResult
  $Res call(
      {@JsonKey(name: 'Tier') int tier, @JsonKey(name: 'URL') String url});
}

/// @nodoc
class _$ChaseStreamCopyWithImpl<$Res, $Val extends ChaseStream>
    implements $ChaseStreamCopyWith<$Res> {
  _$ChaseStreamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChaseStreamCopyWith<$Res>
    implements $ChaseStreamCopyWith<$Res> {
  factory _$$_ChaseStreamCopyWith(
          _$_ChaseStream value, $Res Function(_$_ChaseStream) then) =
      __$$_ChaseStreamCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Tier') int tier, @JsonKey(name: 'URL') String url});
}

/// @nodoc
class __$$_ChaseStreamCopyWithImpl<$Res>
    extends _$ChaseStreamCopyWithImpl<$Res, _$_ChaseStream>
    implements _$$_ChaseStreamCopyWith<$Res> {
  __$$_ChaseStreamCopyWithImpl(
      _$_ChaseStream _value, $Res Function(_$_ChaseStream) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tier = null,
    Object? url = null,
  }) {
    return _then(_$_ChaseStream(
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ChaseStream extends _ChaseStream {
  const _$_ChaseStream(
      {@JsonKey(name: 'Tier') required this.tier,
      @JsonKey(name: 'URL') required this.url})
      : super._();

  factory _$_ChaseStream.fromJson(Map<String, dynamic> json) =>
      _$$_ChaseStreamFromJson(json);

  @override
  @JsonKey(name: 'Tier')
  final int tier;
  @override
  @JsonKey(name: 'URL')
  final String url;

  @override
  String toString() {
    return 'ChaseStream(tier: $tier, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChaseStream &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tier, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChaseStreamCopyWith<_$_ChaseStream> get copyWith =>
      __$$_ChaseStreamCopyWithImpl<_$_ChaseStream>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChaseStreamToJson(
      this,
    );
  }
}

abstract class _ChaseStream extends ChaseStream {
  const factory _ChaseStream(
      {@JsonKey(name: 'Tier') required final int tier,
      @JsonKey(name: 'URL') required final String url}) = _$_ChaseStream;
  const _ChaseStream._() : super._();

  factory _ChaseStream.fromJson(Map<String, dynamic> json) =
      _$_ChaseStream.fromJson;

  @override
  @JsonKey(name: 'Tier')
  int get tier;
  @override
  @JsonKey(name: 'URL')
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$_ChaseStreamCopyWith<_$_ChaseStream> get copyWith =>
      throw _privateConstructorUsedError;
}
