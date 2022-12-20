// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'changelog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Changelog _$ChangelogFromJson(Map<String, dynamic> json) {
  return _Changelog.fromJson(json);
}

/// @nodoc
mixin _$Changelog {
// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'Version')
  String get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'Updates')
  List<String> get updates => throw _privateConstructorUsedError;
  @DatetimeTimestampConverter()
  DateTime get updatedOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'ImageUrl')
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChangelogCopyWith<Changelog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangelogCopyWith<$Res> {
  factory $ChangelogCopyWith(Changelog value, $Res Function(Changelog) then) =
      _$ChangelogCopyWithImpl<$Res, Changelog>;
  @useResult
  $Res call(
      {@JsonKey(name: 'Version') String version,
      @JsonKey(name: 'Title') String? title,
      @JsonKey(name: 'Description') String description,
      @JsonKey(name: 'Updates') List<String> updates,
      @DatetimeTimestampConverter() DateTime updatedOn,
      @JsonKey(name: 'ImageUrl') String? imageUrl});
}

/// @nodoc
class _$ChangelogCopyWithImpl<$Res, $Val extends Changelog>
    implements $ChangelogCopyWith<$Res> {
  _$ChangelogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? title = freezed,
    Object? description = null,
    Object? updates = null,
    Object? updatedOn = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      updates: null == updates
          ? _value.updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedOn: null == updatedOn
          ? _value.updatedOn
          : updatedOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChangelogCopyWith<$Res> implements $ChangelogCopyWith<$Res> {
  factory _$$_ChangelogCopyWith(
          _$_Changelog value, $Res Function(_$_Changelog) then) =
      __$$_ChangelogCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Version') String version,
      @JsonKey(name: 'Title') String? title,
      @JsonKey(name: 'Description') String description,
      @JsonKey(name: 'Updates') List<String> updates,
      @DatetimeTimestampConverter() DateTime updatedOn,
      @JsonKey(name: 'ImageUrl') String? imageUrl});
}

/// @nodoc
class __$$_ChangelogCopyWithImpl<$Res>
    extends _$ChangelogCopyWithImpl<$Res, _$_Changelog>
    implements _$$_ChangelogCopyWith<$Res> {
  __$$_ChangelogCopyWithImpl(
      _$_Changelog _value, $Res Function(_$_Changelog) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? title = freezed,
    Object? description = null,
    Object? updates = null,
    Object? updatedOn = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$_Changelog(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      updates: null == updates
          ? _value._updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedOn: null == updatedOn
          ? _value.updatedOn
          : updatedOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Changelog extends _Changelog {
  const _$_Changelog(
      {@JsonKey(name: 'Version') required this.version,
      @JsonKey(name: 'Title') this.title,
      @JsonKey(name: 'Description') required this.description,
      @JsonKey(name: 'Updates') required final List<String> updates,
      @DatetimeTimestampConverter() required this.updatedOn,
      @JsonKey(name: 'ImageUrl') this.imageUrl})
      : _updates = updates,
        super._();

  factory _$_Changelog.fromJson(Map<String, dynamic> json) =>
      _$$_ChangelogFromJson(json);

// TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @override
  @JsonKey(name: 'Version')
  final String version;
  @override
  @JsonKey(name: 'Title')
  final String? title;
  @override
  @JsonKey(name: 'Description')
  final String description;
  final List<String> _updates;
  @override
  @JsonKey(name: 'Updates')
  List<String> get updates {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updates);
  }

  @override
  @DatetimeTimestampConverter()
  final DateTime updatedOn;
  @override
  @JsonKey(name: 'ImageUrl')
  final String? imageUrl;

  @override
  String toString() {
    return 'Changelog(version: $version, title: $title, description: $description, updates: $updates, updatedOn: $updatedOn, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Changelog &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._updates, _updates) &&
            (identical(other.updatedOn, updatedOn) ||
                other.updatedOn == updatedOn) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, version, title, description,
      const DeepCollectionEquality().hash(_updates), updatedOn, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChangelogCopyWith<_$_Changelog> get copyWith =>
      __$$_ChangelogCopyWithImpl<_$_Changelog>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChangelogToJson(
      this,
    );
  }
}

abstract class _Changelog extends Changelog {
  const factory _Changelog(
      {@JsonKey(name: 'Version') required final String version,
      @JsonKey(name: 'Title') final String? title,
      @JsonKey(name: 'Description') required final String description,
      @JsonKey(name: 'Updates') required final List<String> updates,
      @DatetimeTimestampConverter() required final DateTime updatedOn,
      @JsonKey(name: 'ImageUrl') final String? imageUrl}) = _$_Changelog;
  const _Changelog._() : super._();

  factory _Changelog.fromJson(Map<String, dynamic> json) =
      _$_Changelog.fromJson;

  @override // TODO: Marking as optional for the moment but shoudln't be
// All documents must have an id
  @JsonKey(name: 'Version')
  String get version;
  @override
  @JsonKey(name: 'Title')
  String? get title;
  @override
  @JsonKey(name: 'Description')
  String get description;
  @override
  @JsonKey(name: 'Updates')
  List<String> get updates;
  @override
  @DatetimeTimestampConverter()
  DateTime get updatedOn;
  @override
  @JsonKey(name: 'ImageUrl')
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_ChangelogCopyWith<_$_Changelog> get copyWith =>
      throw _privateConstructorUsedError;
}
