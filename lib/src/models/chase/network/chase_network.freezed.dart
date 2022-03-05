// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chase_network.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChaseNetwork _$ChaseNetworkFromJson(Map<String, dynamic> json) {
  return _ChaseNetwork.fromJson(json);
}

/// @nodoc
class _$ChaseNetworkTearOff {
  const _$ChaseNetworkTearOff();

  _ChaseNetwork call(
      {@JsonKey(name: 'Logo') required String? logo,
      @JsonKey(name: 'Name') required String? name,
      @JsonKey(name: 'Other') required String? other,
      @JsonKey(name: 'Tier') required int? tier,
      @JsonKey(name: 'URL') String? url}) {
    return _ChaseNetwork(
      logo: logo,
      name: name,
      other: other,
      tier: tier,
      url: url,
    );
  }

  ChaseNetwork fromJson(Map<String, Object?> json) {
    return ChaseNetwork.fromJson(json);
  }
}

/// @nodoc
const $ChaseNetwork = _$ChaseNetworkTearOff();

/// @nodoc
mixin _$ChaseNetwork {
  @JsonKey(name: 'Logo')
  String? get logo => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Other')
  String? get other => throw _privateConstructorUsedError;
  @JsonKey(name: 'Tier')
  int? get tier => throw _privateConstructorUsedError;
  @JsonKey(name: 'URL')
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChaseNetworkCopyWith<ChaseNetwork> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChaseNetworkCopyWith<$Res> {
  factory $ChaseNetworkCopyWith(
          ChaseNetwork value, $Res Function(ChaseNetwork) then) =
      _$ChaseNetworkCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'Logo') String? logo,
      @JsonKey(name: 'Name') String? name,
      @JsonKey(name: 'Other') String? other,
      @JsonKey(name: 'Tier') int? tier,
      @JsonKey(name: 'URL') String? url});
}

/// @nodoc
class _$ChaseNetworkCopyWithImpl<$Res> implements $ChaseNetworkCopyWith<$Res> {
  _$ChaseNetworkCopyWithImpl(this._value, this._then);

  final ChaseNetwork _value;
  // ignore: unused_field
  final $Res Function(ChaseNetwork) _then;

  @override
  $Res call({
    Object? logo = freezed,
    Object? name = freezed,
    Object? other = freezed,
    Object? tier = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      logo: logo == freezed
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      other: other == freezed
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as String?,
      tier: tier == freezed
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int?,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$ChaseNetworkCopyWith<$Res>
    implements $ChaseNetworkCopyWith<$Res> {
  factory _$ChaseNetworkCopyWith(
          _ChaseNetwork value, $Res Function(_ChaseNetwork) then) =
      __$ChaseNetworkCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'Logo') String? logo,
      @JsonKey(name: 'Name') String? name,
      @JsonKey(name: 'Other') String? other,
      @JsonKey(name: 'Tier') int? tier,
      @JsonKey(name: 'URL') String? url});
}

/// @nodoc
class __$ChaseNetworkCopyWithImpl<$Res> extends _$ChaseNetworkCopyWithImpl<$Res>
    implements _$ChaseNetworkCopyWith<$Res> {
  __$ChaseNetworkCopyWithImpl(
      _ChaseNetwork _value, $Res Function(_ChaseNetwork) _then)
      : super(_value, (v) => _then(v as _ChaseNetwork));

  @override
  _ChaseNetwork get _value => super._value as _ChaseNetwork;

  @override
  $Res call({
    Object? logo = freezed,
    Object? name = freezed,
    Object? other = freezed,
    Object? tier = freezed,
    Object? url = freezed,
  }) {
    return _then(_ChaseNetwork(
      logo: logo == freezed
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      other: other == freezed
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as String?,
      tier: tier == freezed
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int?,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ChaseNetwork extends _ChaseNetwork {
  const _$_ChaseNetwork(
      {@JsonKey(name: 'Logo') required this.logo,
      @JsonKey(name: 'Name') required this.name,
      @JsonKey(name: 'Other') required this.other,
      @JsonKey(name: 'Tier') required this.tier,
      @JsonKey(name: 'URL') this.url})
      : super._();

  factory _$_ChaseNetwork.fromJson(Map<String, dynamic> json) =>
      _$$_ChaseNetworkFromJson(json);

  @override
  @JsonKey(name: 'Logo')
  final String? logo;
  @override
  @JsonKey(name: 'Name')
  final String? name;
  @override
  @JsonKey(name: 'Other')
  final String? other;
  @override
  @JsonKey(name: 'Tier')
  final int? tier;
  @override
  @JsonKey(name: 'URL')
  final String? url;

  @override
  String toString() {
    return 'ChaseNetwork(logo: $logo, name: $name, other: $other, tier: $tier, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChaseNetwork &&
            const DeepCollectionEquality().equals(other.logo, logo) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.other, this.other) &&
            const DeepCollectionEquality().equals(other.tier, tier) &&
            const DeepCollectionEquality().equals(other.url, url));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(logo),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(other),
      const DeepCollectionEquality().hash(tier),
      const DeepCollectionEquality().hash(url));

  @JsonKey(ignore: true)
  @override
  _$ChaseNetworkCopyWith<_ChaseNetwork> get copyWith =>
      __$ChaseNetworkCopyWithImpl<_ChaseNetwork>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChaseNetworkToJson(this);
  }
}

abstract class _ChaseNetwork extends ChaseNetwork {
  const factory _ChaseNetwork(
      {@JsonKey(name: 'Logo') required String? logo,
      @JsonKey(name: 'Name') required String? name,
      @JsonKey(name: 'Other') required String? other,
      @JsonKey(name: 'Tier') required int? tier,
      @JsonKey(name: 'URL') String? url}) = _$_ChaseNetwork;
  const _ChaseNetwork._() : super._();

  factory _ChaseNetwork.fromJson(Map<String, dynamic> json) =
      _$_ChaseNetwork.fromJson;

  @override
  @JsonKey(name: 'Logo')
  String? get logo;
  @override
  @JsonKey(name: 'Name')
  String? get name;
  @override
  @JsonKey(name: 'Other')
  String? get other;
  @override
  @JsonKey(name: 'Tier')
  int? get tier;
  @override
  @JsonKey(name: 'URL')
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$ChaseNetworkCopyWith<_ChaseNetwork> get copyWith =>
      throw _privateConstructorUsedError;
}
