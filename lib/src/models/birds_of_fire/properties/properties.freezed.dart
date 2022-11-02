// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'properties.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BofProperties _$BofPropertiesFromJson(Map<String, dynamic> json) {
  return _BofProperties.fromJson(json);
}

/// @nodoc
mixin _$BofProperties {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrl')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'group')
  String get group => throw _privateConstructorUsedError;
  @JsonKey(name: 'dbscan')
  String get dbscan => throw _privateConstructorUsedError;
  @JsonKey(name: 'cluster')
  int? get cluster => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BofPropertiesCopyWith<BofProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BofPropertiesCopyWith<$Res> {
  factory $BofPropertiesCopyWith(
          BofProperties value, $Res Function(BofProperties) then) =
      _$BofPropertiesCopyWithImpl<$Res, BofProperties>;
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'imageUrl') String imageUrl,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'group') String group,
      @JsonKey(name: 'dbscan') String dbscan,
      @JsonKey(name: 'cluster') int? cluster});
}

/// @nodoc
class _$BofPropertiesCopyWithImpl<$Res, $Val extends BofProperties>
    implements $BofPropertiesCopyWith<$Res> {
  _$BofPropertiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? imageUrl = null,
    Object? type = null,
    Object? group = null,
    Object? dbscan = null,
    Object? cluster = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      dbscan: null == dbscan
          ? _value.dbscan
          : dbscan // ignore: cast_nullable_to_non_nullable
              as String,
      cluster: freezed == cluster
          ? _value.cluster
          : cluster // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BofPropertiesCopyWith<$Res>
    implements $BofPropertiesCopyWith<$Res> {
  factory _$$_BofPropertiesCopyWith(
          _$_BofProperties value, $Res Function(_$_BofProperties) then) =
      __$$_BofPropertiesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'imageUrl') String imageUrl,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'group') String group,
      @JsonKey(name: 'dbscan') String dbscan,
      @JsonKey(name: 'cluster') int? cluster});
}

/// @nodoc
class __$$_BofPropertiesCopyWithImpl<$Res>
    extends _$BofPropertiesCopyWithImpl<$Res, _$_BofProperties>
    implements _$$_BofPropertiesCopyWith<$Res> {
  __$$_BofPropertiesCopyWithImpl(
      _$_BofProperties _value, $Res Function(_$_BofProperties) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? imageUrl = null,
    Object? type = null,
    Object? group = null,
    Object? dbscan = null,
    Object? cluster = freezed,
  }) {
    return _then(_$_BofProperties(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      dbscan: null == dbscan
          ? _value.dbscan
          : dbscan // ignore: cast_nullable_to_non_nullable
              as String,
      cluster: freezed == cluster
          ? _value.cluster
          : cluster // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_BofProperties extends _BofProperties {
  const _$_BofProperties(
      {@JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'imageUrl') required this.imageUrl,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'group') required this.group,
      @JsonKey(name: 'dbscan') required this.dbscan,
      @JsonKey(name: 'cluster') this.cluster})
      : super._();

  factory _$_BofProperties.fromJson(Map<String, dynamic> json) =>
      _$$_BofPropertiesFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'imageUrl')
  final String imageUrl;
  @override
  @JsonKey(name: 'type')
  final String type;
  @override
  @JsonKey(name: 'group')
  final String group;
  @override
  @JsonKey(name: 'dbscan')
  final String dbscan;
  @override
  @JsonKey(name: 'cluster')
  final int? cluster;

  @override
  String toString() {
    return 'BofProperties(title: $title, imageUrl: $imageUrl, type: $type, group: $group, dbscan: $dbscan, cluster: $cluster)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BofProperties &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.dbscan, dbscan) || other.dbscan == dbscan) &&
            (identical(other.cluster, cluster) || other.cluster == cluster));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, imageUrl, type, group, dbscan, cluster);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BofPropertiesCopyWith<_$_BofProperties> get copyWith =>
      __$$_BofPropertiesCopyWithImpl<_$_BofProperties>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BofPropertiesToJson(
      this,
    );
  }
}

abstract class _BofProperties extends BofProperties {
  const factory _BofProperties(
      {@JsonKey(name: 'title') required final String title,
      @JsonKey(name: 'imageUrl') required final String imageUrl,
      @JsonKey(name: 'type') required final String type,
      @JsonKey(name: 'group') required final String group,
      @JsonKey(name: 'dbscan') required final String dbscan,
      @JsonKey(name: 'cluster') final int? cluster}) = _$_BofProperties;
  const _BofProperties._() : super._();

  factory _BofProperties.fromJson(Map<String, dynamic> json) =
      _$_BofProperties.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'imageUrl')
  String get imageUrl;
  @override
  @JsonKey(name: 'type')
  String get type;
  @override
  @JsonKey(name: 'group')
  String get group;
  @override
  @JsonKey(name: 'dbscan')
  String get dbscan;
  @override
  @JsonKey(name: 'cluster')
  int? get cluster;
  @override
  @JsonKey(ignore: true)
  _$$_BofPropertiesCopyWith<_$_BofProperties> get copyWith =>
      throw _privateConstructorUsedError;
}
