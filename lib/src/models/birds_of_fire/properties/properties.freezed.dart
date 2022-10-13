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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BofPropertiesCopyWith<BofProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BofPropertiesCopyWith<$Res> {
  factory $BofPropertiesCopyWith(
          BofProperties value, $Res Function(BofProperties) then) =
      _$BofPropertiesCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'imageUrl') String imageUrl,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'group') String group,
      @JsonKey(name: 'dbscan') String dbscan});
}

/// @nodoc
class _$BofPropertiesCopyWithImpl<$Res>
    implements $BofPropertiesCopyWith<$Res> {
  _$BofPropertiesCopyWithImpl(this._value, this._then);

  final BofProperties _value;
  // ignore: unused_field
  final $Res Function(BofProperties) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? imageUrl = freezed,
    Object? type = freezed,
    Object? group = freezed,
    Object? dbscan = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      group: group == freezed
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      dbscan: dbscan == freezed
          ? _value.dbscan
          : dbscan // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_BofPropertiesCopyWith<$Res>
    implements $BofPropertiesCopyWith<$Res> {
  factory _$$_BofPropertiesCopyWith(
          _$_BofProperties value, $Res Function(_$_BofProperties) then) =
      __$$_BofPropertiesCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'imageUrl') String imageUrl,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'group') String group,
      @JsonKey(name: 'dbscan') String dbscan});
}

/// @nodoc
class __$$_BofPropertiesCopyWithImpl<$Res>
    extends _$BofPropertiesCopyWithImpl<$Res>
    implements _$$_BofPropertiesCopyWith<$Res> {
  __$$_BofPropertiesCopyWithImpl(
      _$_BofProperties _value, $Res Function(_$_BofProperties) _then)
      : super(_value, (v) => _then(v as _$_BofProperties));

  @override
  _$_BofProperties get _value => super._value as _$_BofProperties;

  @override
  $Res call({
    Object? title = freezed,
    Object? imageUrl = freezed,
    Object? type = freezed,
    Object? group = freezed,
    Object? dbscan = freezed,
  }) {
    return _then(_$_BofProperties(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      group: group == freezed
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      dbscan: dbscan == freezed
          ? _value.dbscan
          : dbscan // ignore: cast_nullable_to_non_nullable
              as String,
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
      @JsonKey(name: 'dbscan') required this.dbscan})
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
  String toString() {
    return 'BofProperties(title: $title, imageUrl: $imageUrl, type: $type, group: $group, dbscan: $dbscan)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BofProperties &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.imageUrl, imageUrl) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.group, group) &&
            const DeepCollectionEquality().equals(other.dbscan, dbscan));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(imageUrl),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(group),
      const DeepCollectionEquality().hash(dbscan));

  @JsonKey(ignore: true)
  @override
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
          @JsonKey(name: 'dbscan') required final String dbscan}) =
      _$_BofProperties;
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
  @JsonKey(ignore: true)
  _$$_BofPropertiesCopyWith<_$_BofProperties> get copyWith =>
      throw _privateConstructorUsedError;
}
