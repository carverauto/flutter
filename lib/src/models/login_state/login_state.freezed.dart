// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$LogInStateTearOff {
  const _$LogInStateTearOff();

  _Data data() {
    return const _Data();
  }

  _MultiAuth multiAuth(
      List<String> existingAuthProviers, AuthCredential authCredential) {
    return _MultiAuth(
      existingAuthProviers,
      authCredential,
    );
  }

  _Loading loading() {
    return const _Loading();
  }

  _Error error(ChaseAppCallException e, [StackTrace? stk]) {
    return _Error(
      e,
      stk,
    );
  }
}

/// @nodoc
const $LogInState = _$LogInStateTearOff();

/// @nodoc
mixin _$LogInState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() data,
    required TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)
        multiAuth,
    required TResult Function() loading,
    required TResult Function(ChaseAppCallException e, StackTrace? stk) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_MultiAuth value) multiAuth,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogInStateCopyWith<$Res> {
  factory $LogInStateCopyWith(
          LogInState value, $Res Function(LogInState) then) =
      _$LogInStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$LogInStateCopyWithImpl<$Res> implements $LogInStateCopyWith<$Res> {
  _$LogInStateCopyWithImpl(this._value, this._then);

  final LogInState _value;
  // ignore: unused_field
  final $Res Function(LogInState) _then;
}

/// @nodoc
abstract class _$DataCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) then) =
      __$DataCopyWithImpl<$Res>;
}

/// @nodoc
class __$DataCopyWithImpl<$Res> extends _$LogInStateCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(_Data _value, $Res Function(_Data) _then)
      : super(_value, (v) => _then(v as _Data));

  @override
  _Data get _value => super._value as _Data;
}

/// @nodoc

class _$_Data implements _Data {
  const _$_Data();

  @override
  String toString() {
    return 'LogInState.data()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Data);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() data,
    required TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)
        multiAuth,
    required TResult Function() loading,
    required TResult Function(ChaseAppCallException e, StackTrace? stk) error,
  }) {
    return data();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
  }) {
    return data?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_MultiAuth value) multiAuth,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data implements LogInState {
  const factory _Data() = _$_Data;
}

/// @nodoc
abstract class _$MultiAuthCopyWith<$Res> {
  factory _$MultiAuthCopyWith(
          _MultiAuth value, $Res Function(_MultiAuth) then) =
      __$MultiAuthCopyWithImpl<$Res>;
  $Res call({List<String> existingAuthProviers, AuthCredential authCredential});
}

/// @nodoc
class __$MultiAuthCopyWithImpl<$Res> extends _$LogInStateCopyWithImpl<$Res>
    implements _$MultiAuthCopyWith<$Res> {
  __$MultiAuthCopyWithImpl(_MultiAuth _value, $Res Function(_MultiAuth) _then)
      : super(_value, (v) => _then(v as _MultiAuth));

  @override
  _MultiAuth get _value => super._value as _MultiAuth;

  @override
  $Res call({
    Object? existingAuthProviers = freezed,
    Object? authCredential = freezed,
  }) {
    return _then(_MultiAuth(
      existingAuthProviers == freezed
          ? _value.existingAuthProviers
          : existingAuthProviers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      authCredential == freezed
          ? _value.authCredential
          : authCredential // ignore: cast_nullable_to_non_nullable
              as AuthCredential,
    ));
  }
}

/// @nodoc

class _$_MultiAuth implements _MultiAuth {
  const _$_MultiAuth(this.existingAuthProviers, this.authCredential);

  @override
  final List<String> existingAuthProviers;
  @override
  final AuthCredential authCredential;

  @override
  String toString() {
    return 'LogInState.multiAuth(existingAuthProviers: $existingAuthProviers, authCredential: $authCredential)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MultiAuth &&
            const DeepCollectionEquality()
                .equals(other.existingAuthProviers, existingAuthProviers) &&
            const DeepCollectionEquality()
                .equals(other.authCredential, authCredential));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(existingAuthProviers),
      const DeepCollectionEquality().hash(authCredential));

  @JsonKey(ignore: true)
  @override
  _$MultiAuthCopyWith<_MultiAuth> get copyWith =>
      __$MultiAuthCopyWithImpl<_MultiAuth>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() data,
    required TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)
        multiAuth,
    required TResult Function() loading,
    required TResult Function(ChaseAppCallException e, StackTrace? stk) error,
  }) {
    return multiAuth(existingAuthProviers, authCredential);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
  }) {
    return multiAuth?.call(existingAuthProviers, authCredential);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
    required TResult orElse(),
  }) {
    if (multiAuth != null) {
      return multiAuth(existingAuthProviers, authCredential);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_MultiAuth value) multiAuth,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return multiAuth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return multiAuth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (multiAuth != null) {
      return multiAuth(this);
    }
    return orElse();
  }
}

abstract class _MultiAuth implements LogInState {
  const factory _MultiAuth(
          List<String> existingAuthProviers, AuthCredential authCredential) =
      _$_MultiAuth;

  List<String> get existingAuthProviers;
  AuthCredential get authCredential;
  @JsonKey(ignore: true)
  _$MultiAuthCopyWith<_MultiAuth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$LoadingCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) then) =
      __$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$LoadingCopyWithImpl<$Res> extends _$LogInStateCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(_Loading _value, $Res Function(_Loading) _then)
      : super(_value, (v) => _then(v as _Loading));

  @override
  _Loading get _value => super._value as _Loading;
}

/// @nodoc

class _$_Loading implements _Loading {
  const _$_Loading();

  @override
  String toString() {
    return 'LogInState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() data,
    required TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)
        multiAuth,
    required TResult Function() loading,
    required TResult Function(ChaseAppCallException e, StackTrace? stk) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_MultiAuth value) multiAuth,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements LogInState {
  const factory _Loading() = _$_Loading;
}

/// @nodoc
abstract class _$ErrorCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) then) =
      __$ErrorCopyWithImpl<$Res>;
  $Res call({ChaseAppCallException e, StackTrace? stk});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> extends _$LogInStateCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(_Error _value, $Res Function(_Error) _then)
      : super(_value, (v) => _then(v as _Error));

  @override
  _Error get _value => super._value as _Error;

  @override
  $Res call({
    Object? e = freezed,
    Object? stk = freezed,
  }) {
    return _then(_Error(
      e == freezed
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as ChaseAppCallException,
      stk == freezed
          ? _value.stk
          : stk // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$_Error implements _Error {
  const _$_Error(this.e, [this.stk]);

  @override
  final ChaseAppCallException e;
  @override
  final StackTrace? stk;

  @override
  String toString() {
    return 'LogInState.error(e: $e, stk: $stk)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            const DeepCollectionEquality().equals(other.e, e) &&
            const DeepCollectionEquality().equals(other.stk, stk));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(e),
      const DeepCollectionEquality().hash(stk));

  @JsonKey(ignore: true)
  @override
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() data,
    required TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)
        multiAuth,
    required TResult Function() loading,
    required TResult Function(ChaseAppCallException e, StackTrace? stk) error,
  }) {
    return error(e, stk);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
  }) {
    return error?.call(e, stk);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? data,
    TResult Function(
            List<String> existingAuthProviers, AuthCredential authCredential)?
        multiAuth,
    TResult Function()? loading,
    TResult Function(ChaseAppCallException e, StackTrace? stk)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(e, stk);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data value) data,
    required TResult Function(_MultiAuth value) multiAuth,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data value)? data,
    TResult Function(_MultiAuth value)? multiAuth,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements LogInState {
  const factory _Error(ChaseAppCallException e, [StackTrace? stk]) = _$_Error;

  ChaseAppCallException get e;
  StackTrace? get stk;
  @JsonKey(ignore: true)
  _$ErrorCopyWith<_Error> get copyWith => throw _privateConstructorUsedError;
}
