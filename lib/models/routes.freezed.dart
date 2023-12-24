// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RoutesModel _$RoutesModelFromJson(Map<String, dynamic> json) {
  return _RoutesModel.fromJson(json);
}

/// @nodoc
mixin _$RoutesModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_no')
  String get referenceNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_by')
  int get createBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_id')
  int? get driverId => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  UserModel? get driver => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_name')
  String get statusName => throw _privateConstructorUsedError;
  List<OrderModel>? get orders => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutesModelCopyWith<RoutesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutesModelCopyWith<$Res> {
  factory $RoutesModelCopyWith(
          RoutesModel value, $Res Function(RoutesModel) then) =
      _$RoutesModelCopyWithImpl<$Res, RoutesModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'reference_no') String referenceNo,
      @JsonKey(name: 'create_by') int createBy,
      @JsonKey(name: 'driver_id') int? driverId,
      int status,
      UserModel? driver,
      @JsonKey(name: 'status_name') String statusName,
      List<OrderModel>? orders,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt});

  $UserModelCopyWith<$Res>? get driver;
}

/// @nodoc
class _$RoutesModelCopyWithImpl<$Res, $Val extends RoutesModel>
    implements $RoutesModelCopyWith<$Res> {
  _$RoutesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNo = null,
    Object? createBy = null,
    Object? driverId = freezed,
    Object? status = null,
    Object? driver = freezed,
    Object? statusName = null,
    Object? orders = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      referenceNo: null == referenceNo
          ? _value.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String,
      createBy: null == createBy
          ? _value.createBy
          : createBy // ignore: cast_nullable_to_non_nullable
              as int,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      driver: freezed == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
      orders: freezed == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get driver {
    if (_value.driver == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.driver!, (value) {
      return _then(_value.copyWith(driver: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoutesModelImplCopyWith<$Res>
    implements $RoutesModelCopyWith<$Res> {
  factory _$$RoutesModelImplCopyWith(
          _$RoutesModelImpl value, $Res Function(_$RoutesModelImpl) then) =
      __$$RoutesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'reference_no') String referenceNo,
      @JsonKey(name: 'create_by') int createBy,
      @JsonKey(name: 'driver_id') int? driverId,
      int status,
      UserModel? driver,
      @JsonKey(name: 'status_name') String statusName,
      List<OrderModel>? orders,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt});

  @override
  $UserModelCopyWith<$Res>? get driver;
}

/// @nodoc
class __$$RoutesModelImplCopyWithImpl<$Res>
    extends _$RoutesModelCopyWithImpl<$Res, _$RoutesModelImpl>
    implements _$$RoutesModelImplCopyWith<$Res> {
  __$$RoutesModelImplCopyWithImpl(
      _$RoutesModelImpl _value, $Res Function(_$RoutesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNo = null,
    Object? createBy = null,
    Object? driverId = freezed,
    Object? status = null,
    Object? driver = freezed,
    Object? statusName = null,
    Object? orders = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_$RoutesModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      referenceNo: null == referenceNo
          ? _value.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String,
      createBy: null == createBy
          ? _value.createBy
          : createBy // ignore: cast_nullable_to_non_nullable
              as int,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      driver: freezed == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
      orders: freezed == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutesModelImpl implements _RoutesModel {
  const _$RoutesModelImpl(
      {required this.id,
      @JsonKey(name: 'reference_no') required this.referenceNo,
      @JsonKey(name: 'create_by') required this.createBy,
      @JsonKey(name: 'driver_id') required this.driverId,
      required this.status,
      required this.driver,
      @JsonKey(name: 'status_name') required this.statusName,
      final List<OrderModel>? orders,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'deleted_at') required this.deletedAt})
      : _orders = orders;

  factory _$RoutesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutesModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'reference_no')
  final String referenceNo;
  @override
  @JsonKey(name: 'create_by')
  final int createBy;
  @override
  @JsonKey(name: 'driver_id')
  final int? driverId;
  @override
  final int status;
  @override
  final UserModel? driver;
  @override
  @JsonKey(name: 'status_name')
  final String statusName;
  final List<OrderModel>? _orders;
  @override
  List<OrderModel>? get orders {
    final value = _orders;
    if (value == null) return null;
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'RoutesModel(id: $id, referenceNo: $referenceNo, createBy: $createBy, driverId: $driverId, status: $status, driver: $driver, statusName: $statusName, orders: $orders, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutesModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.createBy, createBy) ||
                other.createBy == createBy) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            (identical(other.statusName, statusName) ||
                other.statusName == statusName) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      referenceNo,
      createBy,
      driverId,
      status,
      driver,
      statusName,
      const DeepCollectionEquality().hash(_orders),
      createdAt,
      updatedAt,
      deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutesModelImplCopyWith<_$RoutesModelImpl> get copyWith =>
      __$$RoutesModelImplCopyWithImpl<_$RoutesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutesModelImplToJson(
      this,
    );
  }
}

abstract class _RoutesModel implements RoutesModel {
  const factory _RoutesModel(
          {required final int id,
          @JsonKey(name: 'reference_no') required final String referenceNo,
          @JsonKey(name: 'create_by') required final int createBy,
          @JsonKey(name: 'driver_id') required final int? driverId,
          required final int status,
          required final UserModel? driver,
          @JsonKey(name: 'status_name') required final String statusName,
          final List<OrderModel>? orders,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt,
          @JsonKey(name: 'deleted_at') required final DateTime? deletedAt}) =
      _$RoutesModelImpl;

  factory _RoutesModel.fromJson(Map<String, dynamic> json) =
      _$RoutesModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'reference_no')
  String get referenceNo;
  @override
  @JsonKey(name: 'create_by')
  int get createBy;
  @override
  @JsonKey(name: 'driver_id')
  int? get driverId;
  @override
  int get status;
  @override
  UserModel? get driver;
  @override
  @JsonKey(name: 'status_name')
  String get statusName;
  @override
  List<OrderModel>? get orders;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$RoutesModelImplCopyWith<_$RoutesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
