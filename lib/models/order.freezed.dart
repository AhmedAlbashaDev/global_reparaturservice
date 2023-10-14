// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_no')
  String get referenceNo => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get lat => throw _privateConstructorUsedError;
  String get lng => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_device')
  String get maintenanceDevice => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  @JsonKey(name: 'block_no')
  String? get blockNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_paid')
  bool get isPaid => throw _privateConstructorUsedError;
  String? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_id')
  int? get paymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_way')
  dynamic get paymentWay => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  int get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_phone_number')
  String? get orderPhoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_number')
  String? get floorNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'apartment_number')
  String? get apartmentNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_info')
  String? get additionalInfo => throw _privateConstructorUsedError;
  UserModel? get customer => throw _privateConstructorUsedError;
  List<FilesModel>? get files => throw _privateConstructorUsedError;
  @JsonKey(name: 'road_id')
  int? get roadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_visit')
  bool get isVisit => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_visit_id')
  int? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_by')
  int get createBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_name')
  String get statusName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'reference_no') String referenceNo,
      String address,
      String description,
      String lat,
      String lng,
      int status,
      @JsonKey(name: 'maintenance_device') String maintenanceDevice,
      String? brand,
      @JsonKey(name: 'block_no') String? blockNo,
      @JsonKey(name: 'is_paid') bool isPaid,
      String? amount,
      @JsonKey(name: 'payment_id') int? paymentId,
      @JsonKey(name: 'payment_way') dynamic paymentWay,
      @JsonKey(name: 'customer_id') int customerId,
      @JsonKey(name: 'order_phone_number') String? orderPhoneNumber,
      @JsonKey(name: 'floor_number') String? floorNumber,
      @JsonKey(name: 'apartment_number') String? apartmentNumber,
      @JsonKey(name: 'additional_info') String? additionalInfo,
      UserModel? customer,
      List<FilesModel>? files,
      @JsonKey(name: 'road_id') int? roadId,
      @JsonKey(name: 'is_visit') bool isVisit,
      @JsonKey(name: 'first_visit_id') int? orderId,
      @JsonKey(name: 'create_by') int createBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'status_name') String statusName});

  $UserModelCopyWith<$Res>? get customer;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNo = null,
    Object? address = null,
    Object? description = null,
    Object? lat = null,
    Object? lng = null,
    Object? status = null,
    Object? maintenanceDevice = null,
    Object? brand = freezed,
    Object? blockNo = freezed,
    Object? isPaid = null,
    Object? amount = freezed,
    Object? paymentId = freezed,
    Object? paymentWay = freezed,
    Object? customerId = null,
    Object? orderPhoneNumber = freezed,
    Object? floorNumber = freezed,
    Object? apartmentNumber = freezed,
    Object? additionalInfo = freezed,
    Object? customer = freezed,
    Object? files = freezed,
    Object? roadId = freezed,
    Object? isVisit = null,
    Object? orderId = freezed,
    Object? createBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? statusName = null,
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
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      maintenanceDevice: null == maintenanceDevice
          ? _value.maintenanceDevice
          : maintenanceDevice // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      blockNo: freezed == blockNo
          ? _value.blockNo
          : blockNo // ignore: cast_nullable_to_non_nullable
              as String?,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentWay: freezed == paymentWay
          ? _value.paymentWay
          : paymentWay // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      orderPhoneNumber: freezed == orderPhoneNumber
          ? _value.orderPhoneNumber
          : orderPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      apartmentNumber: freezed == apartmentNumber
          ? _value.apartmentNumber
          : apartmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      files: freezed == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FilesModel>?,
      roadId: freezed == roadId
          ? _value.roadId
          : roadId // ignore: cast_nullable_to_non_nullable
              as int?,
      isVisit: null == isVisit
          ? _value.isVisit
          : isVisit // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      createBy: null == createBy
          ? _value.createBy
          : createBy // ignore: cast_nullable_to_non_nullable
              as int,
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
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get customer {
    if (_value.customer == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.customer!, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'reference_no') String referenceNo,
      String address,
      String description,
      String lat,
      String lng,
      int status,
      @JsonKey(name: 'maintenance_device') String maintenanceDevice,
      String? brand,
      @JsonKey(name: 'block_no') String? blockNo,
      @JsonKey(name: 'is_paid') bool isPaid,
      String? amount,
      @JsonKey(name: 'payment_id') int? paymentId,
      @JsonKey(name: 'payment_way') dynamic paymentWay,
      @JsonKey(name: 'customer_id') int customerId,
      @JsonKey(name: 'order_phone_number') String? orderPhoneNumber,
      @JsonKey(name: 'floor_number') String? floorNumber,
      @JsonKey(name: 'apartment_number') String? apartmentNumber,
      @JsonKey(name: 'additional_info') String? additionalInfo,
      UserModel? customer,
      List<FilesModel>? files,
      @JsonKey(name: 'road_id') int? roadId,
      @JsonKey(name: 'is_visit') bool isVisit,
      @JsonKey(name: 'first_visit_id') int? orderId,
      @JsonKey(name: 'create_by') int createBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'status_name') String statusName});

  @override
  $UserModelCopyWith<$Res>? get customer;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNo = null,
    Object? address = null,
    Object? description = null,
    Object? lat = null,
    Object? lng = null,
    Object? status = null,
    Object? maintenanceDevice = null,
    Object? brand = freezed,
    Object? blockNo = freezed,
    Object? isPaid = null,
    Object? amount = freezed,
    Object? paymentId = freezed,
    Object? paymentWay = freezed,
    Object? customerId = null,
    Object? orderPhoneNumber = freezed,
    Object? floorNumber = freezed,
    Object? apartmentNumber = freezed,
    Object? additionalInfo = freezed,
    Object? customer = freezed,
    Object? files = freezed,
    Object? roadId = freezed,
    Object? isVisit = null,
    Object? orderId = freezed,
    Object? createBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? statusName = null,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      referenceNo: null == referenceNo
          ? _value.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      maintenanceDevice: null == maintenanceDevice
          ? _value.maintenanceDevice
          : maintenanceDevice // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      blockNo: freezed == blockNo
          ? _value.blockNo
          : blockNo // ignore: cast_nullable_to_non_nullable
              as String?,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentWay: freezed == paymentWay
          ? _value.paymentWay
          : paymentWay // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      orderPhoneNumber: freezed == orderPhoneNumber
          ? _value.orderPhoneNumber
          : orderPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      apartmentNumber: freezed == apartmentNumber
          ? _value.apartmentNumber
          : apartmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      files: freezed == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FilesModel>?,
      roadId: freezed == roadId
          ? _value.roadId
          : roadId // ignore: cast_nullable_to_non_nullable
              as int?,
      isVisit: null == isVisit
          ? _value.isVisit
          : isVisit // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      createBy: null == createBy
          ? _value.createBy
          : createBy // ignore: cast_nullable_to_non_nullable
              as int,
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
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {required this.id,
      @JsonKey(name: 'reference_no') required this.referenceNo,
      required this.address,
      required this.description,
      required this.lat,
      required this.lng,
      required this.status,
      @JsonKey(name: 'maintenance_device') required this.maintenanceDevice,
      required this.brand,
      @JsonKey(name: 'block_no') required this.blockNo,
      @JsonKey(name: 'is_paid') required this.isPaid,
      required this.amount,
      @JsonKey(name: 'payment_id') required this.paymentId,
      @JsonKey(name: 'payment_way') required this.paymentWay,
      @JsonKey(name: 'customer_id') required this.customerId,
      @JsonKey(name: 'order_phone_number') required this.orderPhoneNumber,
      @JsonKey(name: 'floor_number') required this.floorNumber,
      @JsonKey(name: 'apartment_number') required this.apartmentNumber,
      @JsonKey(name: 'additional_info') required this.additionalInfo,
      required this.customer,
      required final List<FilesModel>? files,
      @JsonKey(name: 'road_id') required this.roadId,
      @JsonKey(name: 'is_visit') required this.isVisit,
      @JsonKey(name: 'first_visit_id') required this.orderId,
      @JsonKey(name: 'create_by') required this.createBy,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'deleted_at') required this.deletedAt,
      @JsonKey(name: 'status_name') required this.statusName})
      : _files = files;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'reference_no')
  final String referenceNo;
  @override
  final String address;
  @override
  final String description;
  @override
  final String lat;
  @override
  final String lng;
  @override
  final int status;
  @override
  @JsonKey(name: 'maintenance_device')
  final String maintenanceDevice;
  @override
  final String? brand;
  @override
  @JsonKey(name: 'block_no')
  final String? blockNo;
  @override
  @JsonKey(name: 'is_paid')
  final bool isPaid;
  @override
  final String? amount;
  @override
  @JsonKey(name: 'payment_id')
  final int? paymentId;
  @override
  @JsonKey(name: 'payment_way')
  final dynamic paymentWay;
  @override
  @JsonKey(name: 'customer_id')
  final int customerId;
  @override
  @JsonKey(name: 'order_phone_number')
  final String? orderPhoneNumber;
  @override
  @JsonKey(name: 'floor_number')
  final String? floorNumber;
  @override
  @JsonKey(name: 'apartment_number')
  final String? apartmentNumber;
  @override
  @JsonKey(name: 'additional_info')
  final String? additionalInfo;
  @override
  final UserModel? customer;
  final List<FilesModel>? _files;
  @override
  List<FilesModel>? get files {
    final value = _files;
    if (value == null) return null;
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'road_id')
  final int? roadId;
  @override
  @JsonKey(name: 'is_visit')
  final bool isVisit;
  @override
  @JsonKey(name: 'first_visit_id')
  final int? orderId;
  @override
  @JsonKey(name: 'create_by')
  final int createBy;
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
  @JsonKey(name: 'status_name')
  final String statusName;

  @override
  String toString() {
    return 'OrderModel(id: $id, referenceNo: $referenceNo, address: $address, description: $description, lat: $lat, lng: $lng, status: $status, maintenanceDevice: $maintenanceDevice, brand: $brand, blockNo: $blockNo, isPaid: $isPaid, amount: $amount, paymentId: $paymentId, paymentWay: $paymentWay, customerId: $customerId, orderPhoneNumber: $orderPhoneNumber, floorNumber: $floorNumber, apartmentNumber: $apartmentNumber, additionalInfo: $additionalInfo, customer: $customer, files: $files, roadId: $roadId, isVisit: $isVisit, orderId: $orderId, createBy: $createBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, statusName: $statusName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.maintenanceDevice, maintenanceDevice) ||
                other.maintenanceDevice == maintenanceDevice) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.blockNo, blockNo) || other.blockNo == blockNo) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            const DeepCollectionEquality()
                .equals(other.paymentWay, paymentWay) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.orderPhoneNumber, orderPhoneNumber) ||
                other.orderPhoneNumber == orderPhoneNumber) &&
            (identical(other.floorNumber, floorNumber) ||
                other.floorNumber == floorNumber) &&
            (identical(other.apartmentNumber, apartmentNumber) ||
                other.apartmentNumber == apartmentNumber) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.roadId, roadId) || other.roadId == roadId) &&
            (identical(other.isVisit, isVisit) || other.isVisit == isVisit) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.createBy, createBy) ||
                other.createBy == createBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.statusName, statusName) ||
                other.statusName == statusName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        referenceNo,
        address,
        description,
        lat,
        lng,
        status,
        maintenanceDevice,
        brand,
        blockNo,
        isPaid,
        amount,
        paymentId,
        const DeepCollectionEquality().hash(paymentWay),
        customerId,
        orderPhoneNumber,
        floorNumber,
        apartmentNumber,
        additionalInfo,
        customer,
        const DeepCollectionEquality().hash(_files),
        roadId,
        isVisit,
        orderId,
        createBy,
        createdAt,
        updatedAt,
        deletedAt,
        statusName
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {required final int id,
      @JsonKey(name: 'reference_no') required final String referenceNo,
      required final String address,
      required final String description,
      required final String lat,
      required final String lng,
      required final int status,
      @JsonKey(name: 'maintenance_device')
      required final String maintenanceDevice,
      required final String? brand,
      @JsonKey(name: 'block_no') required final String? blockNo,
      @JsonKey(name: 'is_paid') required final bool isPaid,
      required final String? amount,
      @JsonKey(name: 'payment_id') required final int? paymentId,
      @JsonKey(name: 'payment_way') required final dynamic paymentWay,
      @JsonKey(name: 'customer_id') required final int customerId,
      @JsonKey(name: 'order_phone_number')
      required final String? orderPhoneNumber,
      @JsonKey(name: 'floor_number') required final String? floorNumber,
      @JsonKey(name: 'apartment_number') required final String? apartmentNumber,
      @JsonKey(name: 'additional_info') required final String? additionalInfo,
      required final UserModel? customer,
      required final List<FilesModel>? files,
      @JsonKey(name: 'road_id') required final int? roadId,
      @JsonKey(name: 'is_visit') required final bool isVisit,
      @JsonKey(name: 'first_visit_id') required final int? orderId,
      @JsonKey(name: 'create_by') required final int createBy,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'deleted_at') required final DateTime? deletedAt,
      @JsonKey(name: 'status_name')
      required final String statusName}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'reference_no')
  String get referenceNo;
  @override
  String get address;
  @override
  String get description;
  @override
  String get lat;
  @override
  String get lng;
  @override
  int get status;
  @override
  @JsonKey(name: 'maintenance_device')
  String get maintenanceDevice;
  @override
  String? get brand;
  @override
  @JsonKey(name: 'block_no')
  String? get blockNo;
  @override
  @JsonKey(name: 'is_paid')
  bool get isPaid;
  @override
  String? get amount;
  @override
  @JsonKey(name: 'payment_id')
  int? get paymentId;
  @override
  @JsonKey(name: 'payment_way')
  dynamic get paymentWay;
  @override
  @JsonKey(name: 'customer_id')
  int get customerId;
  @override
  @JsonKey(name: 'order_phone_number')
  String? get orderPhoneNumber;
  @override
  @JsonKey(name: 'floor_number')
  String? get floorNumber;
  @override
  @JsonKey(name: 'apartment_number')
  String? get apartmentNumber;
  @override
  @JsonKey(name: 'additional_info')
  String? get additionalInfo;
  @override
  UserModel? get customer;
  @override
  List<FilesModel>? get files;
  @override
  @JsonKey(name: 'road_id')
  int? get roadId;
  @override
  @JsonKey(name: 'is_visit')
  bool get isVisit;
  @override
  @JsonKey(name: 'first_visit_id')
  int? get orderId;
  @override
  @JsonKey(name: 'create_by')
  int get createBy;
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
  @JsonKey(name: 'status_name')
  String get statusName;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
