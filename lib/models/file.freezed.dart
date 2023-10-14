// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FilesModel _$FilesModelFromJson(Map<String, dynamic> json) {
  return _FilesModel.fromJson(json);
}

/// @nodoc
mixin _$FilesModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'path_name')
  String get pathName => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_name')
  String get fileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_path')
  String get fullPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilesModelCopyWith<FilesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilesModelCopyWith<$Res> {
  factory $FilesModelCopyWith(
          FilesModel value, $Res Function(FilesModel) then) =
      _$FilesModelCopyWithImpl<$Res, FilesModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'path_name') String pathName,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'full_path') String fullPath});
}

/// @nodoc
class _$FilesModelCopyWithImpl<$Res, $Val extends FilesModel>
    implements $FilesModelCopyWith<$Res> {
  _$FilesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pathName = null,
    Object? fileName = null,
    Object? fullPath = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      pathName: null == pathName
          ? _value.pathName
          : pathName // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fullPath: null == fullPath
          ? _value.fullPath
          : fullPath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilesModelImplCopyWith<$Res>
    implements $FilesModelCopyWith<$Res> {
  factory _$$FilesModelImplCopyWith(
          _$FilesModelImpl value, $Res Function(_$FilesModelImpl) then) =
      __$$FilesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'path_name') String pathName,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'full_path') String fullPath});
}

/// @nodoc
class __$$FilesModelImplCopyWithImpl<$Res>
    extends _$FilesModelCopyWithImpl<$Res, _$FilesModelImpl>
    implements _$$FilesModelImplCopyWith<$Res> {
  __$$FilesModelImplCopyWithImpl(
      _$FilesModelImpl _value, $Res Function(_$FilesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pathName = null,
    Object? fileName = null,
    Object? fullPath = null,
  }) {
    return _then(_$FilesModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      pathName: null == pathName
          ? _value.pathName
          : pathName // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fullPath: null == fullPath
          ? _value.fullPath
          : fullPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilesModelImpl implements _FilesModel {
  const _$FilesModelImpl(
      {required this.id,
      @JsonKey(name: 'path_name') required this.pathName,
      @JsonKey(name: 'file_name') required this.fileName,
      @JsonKey(name: 'full_path') required this.fullPath});

  factory _$FilesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilesModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'path_name')
  final String pathName;
  @override
  @JsonKey(name: 'file_name')
  final String fileName;
  @override
  @JsonKey(name: 'full_path')
  final String fullPath;

  @override
  String toString() {
    return 'FilesModel(id: $id, pathName: $pathName, fileName: $fileName, fullPath: $fullPath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilesModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pathName, pathName) ||
                other.pathName == pathName) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fullPath, fullPath) ||
                other.fullPath == fullPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, pathName, fileName, fullPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilesModelImplCopyWith<_$FilesModelImpl> get copyWith =>
      __$$FilesModelImplCopyWithImpl<_$FilesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilesModelImplToJson(
      this,
    );
  }
}

abstract class _FilesModel implements FilesModel {
  const factory _FilesModel(
          {required final int id,
          @JsonKey(name: 'path_name') required final String pathName,
          @JsonKey(name: 'file_name') required final String fileName,
          @JsonKey(name: 'full_path') required final String fullPath}) =
      _$FilesModelImpl;

  factory _FilesModel.fromJson(Map<String, dynamic> json) =
      _$FilesModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'path_name')
  String get pathName;
  @override
  @JsonKey(name: 'file_name')
  String get fileName;
  @override
  @JsonKey(name: 'full_path')
  String get fullPath;
  @override
  @JsonKey(ignore: true)
  _$$FilesModelImplCopyWith<_$FilesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
