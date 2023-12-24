// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'devices.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Devices _$DevicesFromJson(Map<String, dynamic> json) {
  return _Devices.fromJson(json);
}

/// @nodoc
mixin _$Devices {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DevicesCopyWith<Devices> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DevicesCopyWith<$Res> {
  factory $DevicesCopyWith(Devices value, $Res Function(Devices) then) =
      _$DevicesCopyWithImpl<$Res, Devices>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$DevicesCopyWithImpl<$Res, $Val extends Devices>
    implements $DevicesCopyWith<$Res> {
  _$DevicesCopyWithImpl(this._value, this._then);

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
abstract class _$$DevicesImplCopyWith<$Res> implements $DevicesCopyWith<$Res> {
  factory _$$DevicesImplCopyWith(
          _$DevicesImpl value, $Res Function(_$DevicesImpl) then) =
      __$$DevicesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$DevicesImplCopyWithImpl<$Res>
    extends _$DevicesCopyWithImpl<$Res, _$DevicesImpl>
    implements _$$DevicesImplCopyWith<$Res> {
  __$$DevicesImplCopyWithImpl(
      _$DevicesImpl _value, $Res Function(_$DevicesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$DevicesImpl(
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
class _$DevicesImpl implements _Devices {
  const _$DevicesImpl({required this.id, required this.name});

  factory _$DevicesImpl.fromJson(Map<String, dynamic> json) =>
      _$$DevicesImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'Devices(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DevicesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DevicesImplCopyWith<_$DevicesImpl> get copyWith =>
      __$$DevicesImplCopyWithImpl<_$DevicesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DevicesImplToJson(
      this,
    );
  }
}

abstract class _Devices implements Devices {
  const factory _Devices({required final int id, required final String name}) =
      _$DevicesImpl;

  factory _Devices.fromJson(Map<String, dynamic> json) = _$DevicesImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$DevicesImplCopyWith<_$DevicesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
