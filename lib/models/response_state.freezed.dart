// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ResponseState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) data,
    required TResult Function(Map<String, dynamic>? data) success,
    required TResult Function(List<T> data) dataList,
    required TResult Function(CustomException error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(T data)? data,
    TResult? Function(Map<String, dynamic>? data)? success,
    TResult? Function(List<T> data)? dataList,
    TResult? Function(CustomException error)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? data,
    TResult Function(Map<String, dynamic>? data)? success,
    TResult Function(List<T> data)? dataList,
    TResult Function(CustomException error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle<T> value) idle,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_DataList<T> value) dataList,
    required TResult Function(_Error<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle<T> value)? idle,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_DataList<T> value)? dataList,
    TResult? Function(_Error<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle<T> value)? idle,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Data<T> value)? data,
    TResult Function(_Success<T> value)? success,
    TResult Function(_DataList<T> value)? dataList,
    TResult Function(_Error<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseStateCopyWith<T, $Res> {
  factory $ResponseStateCopyWith(
          ResponseState<T> value, $Res Function(ResponseState<T>) then) =
      _$ResponseStateCopyWithImpl<T, $Res, ResponseState<T>>;
}

/// @nodoc
class _$ResponseStateCopyWithImpl<T, $Res, $Val extends ResponseState<T>>
    implements $ResponseStateCopyWith<T, $Res> {
  _$ResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$IdleImplCopyWith<T, $Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl<T> value, $Res Function(_$IdleImpl<T>) then) =
      __$$IdleImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<T, $Res>
    extends _$ResponseStateCopyWithImpl<T, $Res, _$IdleImpl<T>>
    implements _$$IdleImplCopyWith<T, $Res> {
  __$$IdleImplCopyWithImpl(
      _$IdleImpl<T> _value, $Res Function(_$IdleImpl<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$IdleImpl<T> implements _Idle<T> {
  const _$IdleImpl();

  @override
  String toString() {
    return 'ResponseState<$T>.idle()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) data,
    required TResult Function(Map<String, dynamic>? data) success,
    required TResult Function(List<T> data) dataList,
    required TResult Function(CustomException error) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(T data)? data,
    TResult? Function(Map<String, dynamic>? data)? success,
    TResult? Function(List<T> data)? dataList,
    TResult? Function(CustomException error)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? data,
    TResult Function(Map<String, dynamic>? data)? success,
    TResult Function(List<T> data)? dataList,
    TResult Function(CustomException error)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle<T> value) idle,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_DataList<T> value) dataList,
    required TResult Function(_Error<T> value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle<T> value)? idle,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_DataList<T> value)? dataList,
    TResult? Function(_Error<T> value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle<T> value)? idle,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Data<T> value)? data,
    TResult Function(_Success<T> value)? success,
    TResult Function(_DataList<T> value)? dataList,
    TResult Function(_Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle<T> implements ResponseState<T> {
  const factory _Idle() = _$IdleImpl<T>;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<T, $Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl<T> value, $Res Function(_$LoadingImpl<T>) then) =
      __$$LoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<T, $Res>
    extends _$ResponseStateCopyWithImpl<T, $Res, _$LoadingImpl<T>>
    implements _$$LoadingImplCopyWith<T, $Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl<T> _value, $Res Function(_$LoadingImpl<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl<T> implements _Loading<T> {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ResponseState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) data,
    required TResult Function(Map<String, dynamic>? data) success,
    required TResult Function(List<T> data) dataList,
    required TResult Function(CustomException error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(T data)? data,
    TResult? Function(Map<String, dynamic>? data)? success,
    TResult? Function(List<T> data)? dataList,
    TResult? Function(CustomException error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? data,
    TResult Function(Map<String, dynamic>? data)? success,
    TResult Function(List<T> data)? dataList,
    TResult Function(CustomException error)? error,
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
    required TResult Function(_Idle<T> value) idle,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_DataList<T> value) dataList,
    required TResult Function(_Error<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle<T> value)? idle,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_DataList<T> value)? dataList,
    TResult? Function(_Error<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle<T> value)? idle,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Data<T> value)? data,
    TResult Function(_Success<T> value)? success,
    TResult Function(_DataList<T> value)? dataList,
    TResult Function(_Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading<T> implements ResponseState<T> {
  const factory _Loading() = _$LoadingImpl<T>;
}

/// @nodoc
abstract class _$$DataImplCopyWith<T, $Res> {
  factory _$$DataImplCopyWith(
          _$DataImpl<T> value, $Res Function(_$DataImpl<T>) then) =
      __$$DataImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$DataImplCopyWithImpl<T, $Res>
    extends _$ResponseStateCopyWithImpl<T, $Res, _$DataImpl<T>>
    implements _$$DataImplCopyWith<T, $Res> {
  __$$DataImplCopyWithImpl(
      _$DataImpl<T> _value, $Res Function(_$DataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$DataImpl<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$DataImpl<T> implements _Data<T> {
  const _$DataImpl({required this.data});

  @override
  final T data;

  @override
  String toString() {
    return 'ResponseState<$T>.data(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataImplCopyWith<T, _$DataImpl<T>> get copyWith =>
      __$$DataImplCopyWithImpl<T, _$DataImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) data,
    required TResult Function(Map<String, dynamic>? data) success,
    required TResult Function(List<T> data) dataList,
    required TResult Function(CustomException error) error,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(T data)? data,
    TResult? Function(Map<String, dynamic>? data)? success,
    TResult? Function(List<T> data)? dataList,
    TResult? Function(CustomException error)? error,
  }) {
    return data?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? data,
    TResult Function(Map<String, dynamic>? data)? success,
    TResult Function(List<T> data)? dataList,
    TResult Function(CustomException error)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle<T> value) idle,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_DataList<T> value) dataList,
    required TResult Function(_Error<T> value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle<T> value)? idle,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_DataList<T> value)? dataList,
    TResult? Function(_Error<T> value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle<T> value)? idle,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Data<T> value)? data,
    TResult Function(_Success<T> value)? success,
    TResult Function(_DataList<T> value)? dataList,
    TResult Function(_Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data<T> implements ResponseState<T> {
  const factory _Data({required final T data}) = _$DataImpl<T>;

  T get data;
  @JsonKey(ignore: true)
  _$$DataImplCopyWith<T, _$DataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<T, $Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl<T> value, $Res Function(_$SuccessImpl<T>) then) =
      __$$SuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Map<String, dynamic>? data});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<T, $Res>
    extends _$ResponseStateCopyWithImpl<T, $Res, _$SuccessImpl<T>>
    implements _$$SuccessImplCopyWith<T, $Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl<T> _value, $Res Function(_$SuccessImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$SuccessImpl<T>(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$SuccessImpl<T> implements _Success<T> {
  const _$SuccessImpl({required final Map<String, dynamic>? data})
      : _data = data;

  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ResponseState<$T>.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl<T> &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<T, _$SuccessImpl<T>> get copyWith =>
      __$$SuccessImplCopyWithImpl<T, _$SuccessImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) data,
    required TResult Function(Map<String, dynamic>? data) success,
    required TResult Function(List<T> data) dataList,
    required TResult Function(CustomException error) error,
  }) {
    return success(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(T data)? data,
    TResult? Function(Map<String, dynamic>? data)? success,
    TResult? Function(List<T> data)? dataList,
    TResult? Function(CustomException error)? error,
  }) {
    return success?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? data,
    TResult Function(Map<String, dynamic>? data)? success,
    TResult Function(List<T> data)? dataList,
    TResult Function(CustomException error)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle<T> value) idle,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_DataList<T> value) dataList,
    required TResult Function(_Error<T> value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle<T> value)? idle,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_DataList<T> value)? dataList,
    TResult? Function(_Error<T> value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle<T> value)? idle,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Data<T> value)? data,
    TResult Function(_Success<T> value)? success,
    TResult Function(_DataList<T> value)? dataList,
    TResult Function(_Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success<T> implements ResponseState<T> {
  const factory _Success({required final Map<String, dynamic>? data}) =
      _$SuccessImpl<T>;

  Map<String, dynamic>? get data;
  @JsonKey(ignore: true)
  _$$SuccessImplCopyWith<T, _$SuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DataListImplCopyWith<T, $Res> {
  factory _$$DataListImplCopyWith(
          _$DataListImpl<T> value, $Res Function(_$DataListImpl<T>) then) =
      __$$DataListImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> data});
}

/// @nodoc
class __$$DataListImplCopyWithImpl<T, $Res>
    extends _$ResponseStateCopyWithImpl<T, $Res, _$DataListImpl<T>>
    implements _$$DataListImplCopyWith<T, $Res> {
  __$$DataListImplCopyWithImpl(
      _$DataListImpl<T> _value, $Res Function(_$DataListImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$DataListImpl<T>(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$DataListImpl<T> implements _DataList<T> {
  const _$DataListImpl({required final List<T> data}) : _data = data;

  final List<T> _data;
  @override
  List<T> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ResponseState<$T>.dataList(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataListImpl<T> &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataListImplCopyWith<T, _$DataListImpl<T>> get copyWith =>
      __$$DataListImplCopyWithImpl<T, _$DataListImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) data,
    required TResult Function(Map<String, dynamic>? data) success,
    required TResult Function(List<T> data) dataList,
    required TResult Function(CustomException error) error,
  }) {
    return dataList(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(T data)? data,
    TResult? Function(Map<String, dynamic>? data)? success,
    TResult? Function(List<T> data)? dataList,
    TResult? Function(CustomException error)? error,
  }) {
    return dataList?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? data,
    TResult Function(Map<String, dynamic>? data)? success,
    TResult Function(List<T> data)? dataList,
    TResult Function(CustomException error)? error,
    required TResult orElse(),
  }) {
    if (dataList != null) {
      return dataList(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle<T> value) idle,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_DataList<T> value) dataList,
    required TResult Function(_Error<T> value) error,
  }) {
    return dataList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle<T> value)? idle,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_DataList<T> value)? dataList,
    TResult? Function(_Error<T> value)? error,
  }) {
    return dataList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle<T> value)? idle,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Data<T> value)? data,
    TResult Function(_Success<T> value)? success,
    TResult Function(_DataList<T> value)? dataList,
    TResult Function(_Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (dataList != null) {
      return dataList(this);
    }
    return orElse();
  }
}

abstract class _DataList<T> implements ResponseState<T> {
  const factory _DataList({required final List<T> data}) = _$DataListImpl<T>;

  List<T> get data;
  @JsonKey(ignore: true)
  _$$DataListImplCopyWith<T, _$DataListImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<T, $Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl<T> value, $Res Function(_$ErrorImpl<T>) then) =
      __$$ErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({CustomException error});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<T, $Res>
    extends _$ResponseStateCopyWithImpl<T, $Res, _$ErrorImpl<T>>
    implements _$$ErrorImplCopyWith<T, $Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl<T> _value, $Res Function(_$ErrorImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$ErrorImpl<T>(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as CustomException,
    ));
  }
}

/// @nodoc

class _$ErrorImpl<T> implements _Error<T> {
  const _$ErrorImpl({required this.error});

  @override
  final CustomException error;

  @override
  String toString() {
    return 'ResponseState<$T>.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      __$$ErrorImplCopyWithImpl<T, _$ErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) data,
    required TResult Function(Map<String, dynamic>? data) success,
    required TResult Function(List<T> data) dataList,
    required TResult Function(CustomException error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(T data)? data,
    TResult? Function(Map<String, dynamic>? data)? success,
    TResult? Function(List<T> data)? dataList,
    TResult? Function(CustomException error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? data,
    TResult Function(Map<String, dynamic>? data)? success,
    TResult Function(List<T> data)? dataList,
    TResult Function(CustomException error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle<T> value) idle,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_DataList<T> value) dataList,
    required TResult Function(_Error<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle<T> value)? idle,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_DataList<T> value)? dataList,
    TResult? Function(_Error<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle<T> value)? idle,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Data<T> value)? data,
    TResult Function(_Success<T> value)? success,
    TResult Function(_DataList<T> value)? dataList,
    TResult Function(_Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error<T> implements ResponseState<T> {
  const factory _Error({required final CustomException error}) = _$ErrorImpl<T>;

  CustomException get error;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
