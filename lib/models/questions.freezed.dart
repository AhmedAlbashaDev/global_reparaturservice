// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Questions _$QuestionsFromJson(Map<String, dynamic> json) {
  return _Questions.fromJson(json);
}

/// @nodoc
mixin _$Questions {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionsCopyWith<Questions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionsCopyWith<$Res> {
  factory $QuestionsCopyWith(Questions value, $Res Function(Questions) then) =
      _$QuestionsCopyWithImpl<$Res, Questions>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$QuestionsCopyWithImpl<$Res, $Val extends Questions>
    implements $QuestionsCopyWith<$Res> {
  _$QuestionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionsImplCopyWith<$Res>
    implements $QuestionsCopyWith<$Res> {
  factory _$$QuestionsImplCopyWith(
          _$QuestionsImpl value, $Res Function(_$QuestionsImpl) then) =
      __$$QuestionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$QuestionsImplCopyWithImpl<$Res>
    extends _$QuestionsCopyWithImpl<$Res, _$QuestionsImpl>
    implements _$$QuestionsImplCopyWith<$Res> {
  __$$QuestionsImplCopyWithImpl(
      _$QuestionsImpl _value, $Res Function(_$QuestionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$QuestionsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionsImpl implements _Questions {
  const _$QuestionsImpl({required this.id, required this.name});

  factory _$QuestionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionsImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'Questions(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionsImplCopyWith<_$QuestionsImpl> get copyWith =>
      __$$QuestionsImplCopyWithImpl<_$QuestionsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionsImplToJson(
      this,
    );
  }
}

abstract class _Questions implements Questions {
  const factory _Questions(
      {required final int id, required final String name}) = _$QuestionsImpl;

  factory _Questions.fromJson(Map<String, dynamic> json) =
      _$QuestionsImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$QuestionsImplCopyWith<_$QuestionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
