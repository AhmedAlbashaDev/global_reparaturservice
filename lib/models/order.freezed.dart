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
  String? get information => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  double? get vat => throw _privateConstructorUsedError;
  double? get subtotal => throw _privateConstructorUsedError;
  double? get total => throw _privateConstructorUsedError;
  String? get report => throw _privateConstructorUsedError;
  List<FilesModel>? get files => throw _privateConstructorUsedError;
  UserModel get customer => throw _privateConstructorUsedError;
  Guarantees? get guarantee => throw _privateConstructorUsedError;
  List<Item>? get items => throw _privateConstructorUsedError;
  List<Devices>? get devices => throw _privateConstructorUsedError;
  List<Questions>? get questions => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_no')
  String get referenceNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_id')
  int? get driverId => throw _privateConstructorUsedError;
  @JsonKey(name: 'problem_summary')
  String get problemSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_name')
  String get typeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_device')
  String get maintenanceDevice => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_paid')
  bool get isPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pickup')
  bool get isPickup => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_time')
  String? get visitTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_id')
  String? get paymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_way')
  dynamic get paymentWay => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  int get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickupAddress')
  DeliveryAddress? get deliveryAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_phone_number')
  String? get orderPhoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_number')
  int? get floorNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'apartment_number')
  String? get apartmentNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_info')
  String? get additionalInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_link')
  String get pdfLink => throw _privateConstructorUsedError;
  @JsonKey(name: 'road_id')
  int? get roadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_mode')
  int? get orderMode => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'zone_area')
  String? get zoneArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  int get postalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_maintenance_price')
  double? get maxMaintenancePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_amount')
  double? get paidAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_file')
  String? get paymentFile => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_order_ref')
  String? get pickupOrderRef => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_amount_received')
  bool get isAmountReceived => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_customer_confirm')
  bool get isCustomerConfirm => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_visit_time')
  String? get orderVisitTime => throw _privateConstructorUsedError;

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
      String? information,
      String address,
      String brand,
      String city,
      double lat,
      double lng,
      int status,
      int type,
      double? vat,
      double? subtotal,
      double? total,
      String? report,
      List<FilesModel>? files,
      UserModel customer,
      Guarantees? guarantee,
      List<Item>? items,
      List<Devices>? devices,
      List<Questions>? questions,
      @JsonKey(name: 'reference_no') String referenceNo,
      @JsonKey(name: 'driver_id') int? driverId,
      @JsonKey(name: 'problem_summary') String problemSummary,
      @JsonKey(name: 'type_name') String typeName,
      @JsonKey(name: 'maintenance_device') String maintenanceDevice,
      @JsonKey(name: 'is_paid') bool isPaid,
      @JsonKey(name: 'is_pickup') bool isPickup,
      @JsonKey(name: 'visit_time') String? visitTime,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'payment_way') dynamic paymentWay,
      @JsonKey(name: 'customer_id') int customerId,
      @JsonKey(name: 'pickupAddress') DeliveryAddress? deliveryAddress,
      @JsonKey(name: 'order_phone_number') String? orderPhoneNumber,
      @JsonKey(name: 'floor_number') int? floorNumber,
      @JsonKey(name: 'apartment_number') String? apartmentNumber,
      @JsonKey(name: 'additional_info') String? additionalInfo,
      @JsonKey(name: 'pdf_link') String pdfLink,
      @JsonKey(name: 'road_id') int? roadId,
      @JsonKey(name: 'order_mode') int? orderMode,
      @JsonKey(name: 'first_visit_id') int? orderId,
      @JsonKey(name: 'create_by') int createBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'status_name') String statusName,
      @JsonKey(name: 'zone_area') String? zoneArea,
      @JsonKey(name: 'postal_code') int postalCode,
      @JsonKey(name: 'max_maintenance_price') double? maxMaintenancePrice,
      @JsonKey(name: 'paid_amount') double? paidAmount,
      @JsonKey(name: 'payment_file') String? paymentFile,
      @JsonKey(name: 'pickup_order_ref') String? pickupOrderRef,
      @JsonKey(name: 'is_amount_received') bool isAmountReceived,
      @JsonKey(name: 'is_customer_confirm') bool isCustomerConfirm,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'order_visit_time') String? orderVisitTime});

  $UserModelCopyWith<$Res> get customer;
  $GuaranteesCopyWith<$Res>? get guarantee;
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress;
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
    Object? information = freezed,
    Object? address = null,
    Object? brand = null,
    Object? city = null,
    Object? lat = null,
    Object? lng = null,
    Object? status = null,
    Object? type = null,
    Object? vat = freezed,
    Object? subtotal = freezed,
    Object? total = freezed,
    Object? report = freezed,
    Object? files = freezed,
    Object? customer = null,
    Object? guarantee = freezed,
    Object? items = freezed,
    Object? devices = freezed,
    Object? questions = freezed,
    Object? referenceNo = null,
    Object? driverId = freezed,
    Object? problemSummary = null,
    Object? typeName = null,
    Object? maintenanceDevice = null,
    Object? isPaid = null,
    Object? isPickup = null,
    Object? visitTime = freezed,
    Object? paymentId = freezed,
    Object? paymentWay = freezed,
    Object? customerId = null,
    Object? deliveryAddress = freezed,
    Object? orderPhoneNumber = freezed,
    Object? floorNumber = freezed,
    Object? apartmentNumber = freezed,
    Object? additionalInfo = freezed,
    Object? pdfLink = null,
    Object? roadId = freezed,
    Object? orderMode = freezed,
    Object? orderId = freezed,
    Object? createBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? statusName = null,
    Object? zoneArea = freezed,
    Object? postalCode = null,
    Object? maxMaintenancePrice = freezed,
    Object? paidAmount = freezed,
    Object? paymentFile = freezed,
    Object? pickupOrderRef = freezed,
    Object? isAmountReceived = null,
    Object? isCustomerConfirm = null,
    Object? paymentMethod = freezed,
    Object? orderVisitTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      information: freezed == information
          ? _value.information
          : information // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      vat: freezed == vat
          ? _value.vat
          : vat // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double?,
      report: freezed == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as String?,
      files: freezed == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FilesModel>?,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as UserModel,
      guarantee: freezed == guarantee
          ? _value.guarantee
          : guarantee // ignore: cast_nullable_to_non_nullable
              as Guarantees?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
      devices: freezed == devices
          ? _value.devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<Devices>?,
      questions: freezed == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Questions>?,
      referenceNo: null == referenceNo
          ? _value.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as int?,
      problemSummary: null == problemSummary
          ? _value.problemSummary
          : problemSummary // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
      maintenanceDevice: null == maintenanceDevice
          ? _value.maintenanceDevice
          : maintenanceDevice // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      isPickup: null == isPickup
          ? _value.isPickup
          : isPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      visitTime: freezed == visitTime
          ? _value.visitTime
          : visitTime // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentWay: freezed == paymentWay
          ? _value.paymentWay
          : paymentWay // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      deliveryAddress: freezed == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as DeliveryAddress?,
      orderPhoneNumber: freezed == orderPhoneNumber
          ? _value.orderPhoneNumber
          : orderPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      apartmentNumber: freezed == apartmentNumber
          ? _value.apartmentNumber
          : apartmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfLink: null == pdfLink
          ? _value.pdfLink
          : pdfLink // ignore: cast_nullable_to_non_nullable
              as String,
      roadId: freezed == roadId
          ? _value.roadId
          : roadId // ignore: cast_nullable_to_non_nullable
              as int?,
      orderMode: freezed == orderMode
          ? _value.orderMode
          : orderMode // ignore: cast_nullable_to_non_nullable
              as int?,
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
      zoneArea: freezed == zoneArea
          ? _value.zoneArea
          : zoneArea // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as int,
      maxMaintenancePrice: freezed == maxMaintenancePrice
          ? _value.maxMaintenancePrice
          : maxMaintenancePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAmount: freezed == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentFile: freezed == paymentFile
          ? _value.paymentFile
          : paymentFile // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupOrderRef: freezed == pickupOrderRef
          ? _value.pickupOrderRef
          : pickupOrderRef // ignore: cast_nullable_to_non_nullable
              as String?,
      isAmountReceived: null == isAmountReceived
          ? _value.isAmountReceived
          : isAmountReceived // ignore: cast_nullable_to_non_nullable
              as bool,
      isCustomerConfirm: null == isCustomerConfirm
          ? _value.isCustomerConfirm
          : isCustomerConfirm // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      orderVisitTime: freezed == orderVisitTime
          ? _value.orderVisitTime
          : orderVisitTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get customer {
    return $UserModelCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GuaranteesCopyWith<$Res>? get guarantee {
    if (_value.guarantee == null) {
      return null;
    }

    return $GuaranteesCopyWith<$Res>(_value.guarantee!, (value) {
      return _then(_value.copyWith(guarantee: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress {
    if (_value.deliveryAddress == null) {
      return null;
    }

    return $DeliveryAddressCopyWith<$Res>(_value.deliveryAddress!, (value) {
      return _then(_value.copyWith(deliveryAddress: value) as $Val);
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
      String? information,
      String address,
      String brand,
      String city,
      double lat,
      double lng,
      int status,
      int type,
      double? vat,
      double? subtotal,
      double? total,
      String? report,
      List<FilesModel>? files,
      UserModel customer,
      Guarantees? guarantee,
      List<Item>? items,
      List<Devices>? devices,
      List<Questions>? questions,
      @JsonKey(name: 'reference_no') String referenceNo,
      @JsonKey(name: 'driver_id') int? driverId,
      @JsonKey(name: 'problem_summary') String problemSummary,
      @JsonKey(name: 'type_name') String typeName,
      @JsonKey(name: 'maintenance_device') String maintenanceDevice,
      @JsonKey(name: 'is_paid') bool isPaid,
      @JsonKey(name: 'is_pickup') bool isPickup,
      @JsonKey(name: 'visit_time') String? visitTime,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'payment_way') dynamic paymentWay,
      @JsonKey(name: 'customer_id') int customerId,
      @JsonKey(name: 'pickupAddress') DeliveryAddress? deliveryAddress,
      @JsonKey(name: 'order_phone_number') String? orderPhoneNumber,
      @JsonKey(name: 'floor_number') int? floorNumber,
      @JsonKey(name: 'apartment_number') String? apartmentNumber,
      @JsonKey(name: 'additional_info') String? additionalInfo,
      @JsonKey(name: 'pdf_link') String pdfLink,
      @JsonKey(name: 'road_id') int? roadId,
      @JsonKey(name: 'order_mode') int? orderMode,
      @JsonKey(name: 'first_visit_id') int? orderId,
      @JsonKey(name: 'create_by') int createBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'status_name') String statusName,
      @JsonKey(name: 'zone_area') String? zoneArea,
      @JsonKey(name: 'postal_code') int postalCode,
      @JsonKey(name: 'max_maintenance_price') double? maxMaintenancePrice,
      @JsonKey(name: 'paid_amount') double? paidAmount,
      @JsonKey(name: 'payment_file') String? paymentFile,
      @JsonKey(name: 'pickup_order_ref') String? pickupOrderRef,
      @JsonKey(name: 'is_amount_received') bool isAmountReceived,
      @JsonKey(name: 'is_customer_confirm') bool isCustomerConfirm,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      @JsonKey(name: 'order_visit_time') String? orderVisitTime});

  @override
  $UserModelCopyWith<$Res> get customer;
  @override
  $GuaranteesCopyWith<$Res>? get guarantee;
  @override
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress;
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
    Object? information = freezed,
    Object? address = null,
    Object? brand = null,
    Object? city = null,
    Object? lat = null,
    Object? lng = null,
    Object? status = null,
    Object? type = null,
    Object? vat = freezed,
    Object? subtotal = freezed,
    Object? total = freezed,
    Object? report = freezed,
    Object? files = freezed,
    Object? customer = null,
    Object? guarantee = freezed,
    Object? items = freezed,
    Object? devices = freezed,
    Object? questions = freezed,
    Object? referenceNo = null,
    Object? driverId = freezed,
    Object? problemSummary = null,
    Object? typeName = null,
    Object? maintenanceDevice = null,
    Object? isPaid = null,
    Object? isPickup = null,
    Object? visitTime = freezed,
    Object? paymentId = freezed,
    Object? paymentWay = freezed,
    Object? customerId = null,
    Object? deliveryAddress = freezed,
    Object? orderPhoneNumber = freezed,
    Object? floorNumber = freezed,
    Object? apartmentNumber = freezed,
    Object? additionalInfo = freezed,
    Object? pdfLink = null,
    Object? roadId = freezed,
    Object? orderMode = freezed,
    Object? orderId = freezed,
    Object? createBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? statusName = null,
    Object? zoneArea = freezed,
    Object? postalCode = null,
    Object? maxMaintenancePrice = freezed,
    Object? paidAmount = freezed,
    Object? paymentFile = freezed,
    Object? pickupOrderRef = freezed,
    Object? isAmountReceived = null,
    Object? isCustomerConfirm = null,
    Object? paymentMethod = freezed,
    Object? orderVisitTime = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      information: freezed == information
          ? _value.information
          : information // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      vat: freezed == vat
          ? _value.vat
          : vat // ignore: cast_nullable_to_non_nullable
              as double?,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double?,
      report: freezed == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as String?,
      files: freezed == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<FilesModel>?,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as UserModel,
      guarantee: freezed == guarantee
          ? _value.guarantee
          : guarantee // ignore: cast_nullable_to_non_nullable
              as Guarantees?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>?,
      devices: freezed == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<Devices>?,
      questions: freezed == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Questions>?,
      referenceNo: null == referenceNo
          ? _value.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as int?,
      problemSummary: null == problemSummary
          ? _value.problemSummary
          : problemSummary // ignore: cast_nullable_to_non_nullable
              as String,
      typeName: null == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String,
      maintenanceDevice: null == maintenanceDevice
          ? _value.maintenanceDevice
          : maintenanceDevice // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      isPickup: null == isPickup
          ? _value.isPickup
          : isPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      visitTime: freezed == visitTime
          ? _value.visitTime
          : visitTime // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentWay: freezed == paymentWay
          ? _value.paymentWay
          : paymentWay // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      deliveryAddress: freezed == deliveryAddress
          ? _value.deliveryAddress
          : deliveryAddress // ignore: cast_nullable_to_non_nullable
              as DeliveryAddress?,
      orderPhoneNumber: freezed == orderPhoneNumber
          ? _value.orderPhoneNumber
          : orderPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      apartmentNumber: freezed == apartmentNumber
          ? _value.apartmentNumber
          : apartmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfLink: null == pdfLink
          ? _value.pdfLink
          : pdfLink // ignore: cast_nullable_to_non_nullable
              as String,
      roadId: freezed == roadId
          ? _value.roadId
          : roadId // ignore: cast_nullable_to_non_nullable
              as int?,
      orderMode: freezed == orderMode
          ? _value.orderMode
          : orderMode // ignore: cast_nullable_to_non_nullable
              as int?,
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
      zoneArea: freezed == zoneArea
          ? _value.zoneArea
          : zoneArea // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as int,
      maxMaintenancePrice: freezed == maxMaintenancePrice
          ? _value.maxMaintenancePrice
          : maxMaintenancePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      paidAmount: freezed == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentFile: freezed == paymentFile
          ? _value.paymentFile
          : paymentFile // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupOrderRef: freezed == pickupOrderRef
          ? _value.pickupOrderRef
          : pickupOrderRef // ignore: cast_nullable_to_non_nullable
              as String?,
      isAmountReceived: null == isAmountReceived
          ? _value.isAmountReceived
          : isAmountReceived // ignore: cast_nullable_to_non_nullable
              as bool,
      isCustomerConfirm: null == isCustomerConfirm
          ? _value.isCustomerConfirm
          : isCustomerConfirm // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      orderVisitTime: freezed == orderVisitTime
          ? _value.orderVisitTime
          : orderVisitTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {required this.id,
      required this.information,
      required this.address,
      required this.brand,
      required this.city,
      required this.lat,
      required this.lng,
      required this.status,
      required this.type,
      required this.vat,
      required this.subtotal,
      required this.total,
      required this.report,
      required final List<FilesModel>? files,
      required this.customer,
      required this.guarantee,
      required final List<Item>? items,
      required final List<Devices>? devices,
      required final List<Questions>? questions,
      @JsonKey(name: 'reference_no') required this.referenceNo,
      @JsonKey(name: 'driver_id') required this.driverId,
      @JsonKey(name: 'problem_summary') required this.problemSummary,
      @JsonKey(name: 'type_name') required this.typeName,
      @JsonKey(name: 'maintenance_device') required this.maintenanceDevice,
      @JsonKey(name: 'is_paid') required this.isPaid,
      @JsonKey(name: 'is_pickup') required this.isPickup,
      @JsonKey(name: 'visit_time') required this.visitTime,
      @JsonKey(name: 'payment_id') required this.paymentId,
      @JsonKey(name: 'payment_way') required this.paymentWay,
      @JsonKey(name: 'customer_id') required this.customerId,
      @JsonKey(name: 'pickupAddress') required this.deliveryAddress,
      @JsonKey(name: 'order_phone_number') required this.orderPhoneNumber,
      @JsonKey(name: 'floor_number') required this.floorNumber,
      @JsonKey(name: 'apartment_number') required this.apartmentNumber,
      @JsonKey(name: 'additional_info') required this.additionalInfo,
      @JsonKey(name: 'pdf_link') required this.pdfLink,
      @JsonKey(name: 'road_id') required this.roadId,
      @JsonKey(name: 'order_mode') required this.orderMode,
      @JsonKey(name: 'first_visit_id') required this.orderId,
      @JsonKey(name: 'create_by') required this.createBy,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'deleted_at') required this.deletedAt,
      @JsonKey(name: 'status_name') required this.statusName,
      @JsonKey(name: 'zone_area') required this.zoneArea,
      @JsonKey(name: 'postal_code') required this.postalCode,
      @JsonKey(name: 'max_maintenance_price') required this.maxMaintenancePrice,
      @JsonKey(name: 'paid_amount') required this.paidAmount,
      @JsonKey(name: 'payment_file') required this.paymentFile,
      @JsonKey(name: 'pickup_order_ref') required this.pickupOrderRef,
      @JsonKey(name: 'is_amount_received') required this.isAmountReceived,
      @JsonKey(name: 'is_customer_confirm') required this.isCustomerConfirm,
      @JsonKey(name: 'payment_method') required this.paymentMethod,
      @JsonKey(name: 'order_visit_time') required this.orderVisitTime})
      : _files = files,
        _items = items,
        _devices = devices,
        _questions = questions;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final int id;
  @override
  final String? information;
  @override
  final String address;
  @override
  final String brand;
  @override
  final String city;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final int status;
  @override
  final int type;
  @override
  final double? vat;
  @override
  final double? subtotal;
  @override
  final double? total;
  @override
  final String? report;
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
  final UserModel customer;
  @override
  final Guarantees? guarantee;
  final List<Item>? _items;
  @override
  List<Item>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Devices>? _devices;
  @override
  List<Devices>? get devices {
    final value = _devices;
    if (value == null) return null;
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Questions>? _questions;
  @override
  List<Questions>? get questions {
    final value = _questions;
    if (value == null) return null;
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'reference_no')
  final String referenceNo;
  @override
  @JsonKey(name: 'driver_id')
  final int? driverId;
  @override
  @JsonKey(name: 'problem_summary')
  final String problemSummary;
  @override
  @JsonKey(name: 'type_name')
  final String typeName;
  @override
  @JsonKey(name: 'maintenance_device')
  final String maintenanceDevice;
  @override
  @JsonKey(name: 'is_paid')
  final bool isPaid;
  @override
  @JsonKey(name: 'is_pickup')
  final bool isPickup;
  @override
  @JsonKey(name: 'visit_time')
  final String? visitTime;
  @override
  @JsonKey(name: 'payment_id')
  final String? paymentId;
  @override
  @JsonKey(name: 'payment_way')
  final dynamic paymentWay;
  @override
  @JsonKey(name: 'customer_id')
  final int customerId;
  @override
  @JsonKey(name: 'pickupAddress')
  final DeliveryAddress? deliveryAddress;
  @override
  @JsonKey(name: 'order_phone_number')
  final String? orderPhoneNumber;
  @override
  @JsonKey(name: 'floor_number')
  final int? floorNumber;
  @override
  @JsonKey(name: 'apartment_number')
  final String? apartmentNumber;
  @override
  @JsonKey(name: 'additional_info')
  final String? additionalInfo;
  @override
  @JsonKey(name: 'pdf_link')
  final String pdfLink;
  @override
  @JsonKey(name: 'road_id')
  final int? roadId;
  @override
  @JsonKey(name: 'order_mode')
  final int? orderMode;
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
  @JsonKey(name: 'zone_area')
  final String? zoneArea;
  @override
  @JsonKey(name: 'postal_code')
  final int postalCode;
  @override
  @JsonKey(name: 'max_maintenance_price')
  final double? maxMaintenancePrice;
  @override
  @JsonKey(name: 'paid_amount')
  final double? paidAmount;
  @override
  @JsonKey(name: 'payment_file')
  final String? paymentFile;
  @override
  @JsonKey(name: 'pickup_order_ref')
  final String? pickupOrderRef;
  @override
  @JsonKey(name: 'is_amount_received')
  final bool isAmountReceived;
  @override
  @JsonKey(name: 'is_customer_confirm')
  final bool isCustomerConfirm;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @JsonKey(name: 'order_visit_time')
  final String? orderVisitTime;

  @override
  String toString() {
    return 'OrderModel(id: $id, information: $information, address: $address, brand: $brand, city: $city, lat: $lat, lng: $lng, status: $status, type: $type, vat: $vat, subtotal: $subtotal, total: $total, report: $report, files: $files, customer: $customer, guarantee: $guarantee, items: $items, devices: $devices, questions: $questions, referenceNo: $referenceNo, driverId: $driverId, problemSummary: $problemSummary, typeName: $typeName, maintenanceDevice: $maintenanceDevice, isPaid: $isPaid, isPickup: $isPickup, visitTime: $visitTime, paymentId: $paymentId, paymentWay: $paymentWay, customerId: $customerId, deliveryAddress: $deliveryAddress, orderPhoneNumber: $orderPhoneNumber, floorNumber: $floorNumber, apartmentNumber: $apartmentNumber, additionalInfo: $additionalInfo, pdfLink: $pdfLink, roadId: $roadId, orderMode: $orderMode, orderId: $orderId, createBy: $createBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, statusName: $statusName, zoneArea: $zoneArea, postalCode: $postalCode, maxMaintenancePrice: $maxMaintenancePrice, paidAmount: $paidAmount, paymentFile: $paymentFile, pickupOrderRef: $pickupOrderRef, isAmountReceived: $isAmountReceived, isCustomerConfirm: $isCustomerConfirm, paymentMethod: $paymentMethod, orderVisitTime: $orderVisitTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.information, information) ||
                other.information == information) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.vat, vat) || other.vat == vat) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.report, report) || other.report == report) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.guarantee, guarantee) ||
                other.guarantee == guarantee) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._devices, _devices) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.problemSummary, problemSummary) ||
                other.problemSummary == problemSummary) &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName) &&
            (identical(other.maintenanceDevice, maintenanceDevice) ||
                other.maintenanceDevice == maintenanceDevice) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid) &&
            (identical(other.isPickup, isPickup) ||
                other.isPickup == isPickup) &&
            (identical(other.visitTime, visitTime) ||
                other.visitTime == visitTime) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            const DeepCollectionEquality()
                .equals(other.paymentWay, paymentWay) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.orderPhoneNumber, orderPhoneNumber) ||
                other.orderPhoneNumber == orderPhoneNumber) &&
            (identical(other.floorNumber, floorNumber) ||
                other.floorNumber == floorNumber) &&
            (identical(other.apartmentNumber, apartmentNumber) ||
                other.apartmentNumber == apartmentNumber) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo) &&
            (identical(other.pdfLink, pdfLink) || other.pdfLink == pdfLink) &&
            (identical(other.roadId, roadId) || other.roadId == roadId) &&
            (identical(other.orderMode, orderMode) ||
                other.orderMode == orderMode) &&
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
                other.statusName == statusName) &&
            (identical(other.zoneArea, zoneArea) ||
                other.zoneArea == zoneArea) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.maxMaintenancePrice, maxMaintenancePrice) ||
                other.maxMaintenancePrice == maxMaintenancePrice) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.paymentFile, paymentFile) ||
                other.paymentFile == paymentFile) &&
            (identical(other.pickupOrderRef, pickupOrderRef) ||
                other.pickupOrderRef == pickupOrderRef) &&
            (identical(other.isAmountReceived, isAmountReceived) ||
                other.isAmountReceived == isAmountReceived) &&
            (identical(other.isCustomerConfirm, isCustomerConfirm) ||
                other.isCustomerConfirm == isCustomerConfirm) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.orderVisitTime, orderVisitTime) ||
                other.orderVisitTime == orderVisitTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        information,
        address,
        brand,
        city,
        lat,
        lng,
        status,
        type,
        vat,
        subtotal,
        total,
        report,
        const DeepCollectionEquality().hash(_files),
        customer,
        guarantee,
        const DeepCollectionEquality().hash(_items),
        const DeepCollectionEquality().hash(_devices),
        const DeepCollectionEquality().hash(_questions),
        referenceNo,
        driverId,
        problemSummary,
        typeName,
        maintenanceDevice,
        isPaid,
        isPickup,
        visitTime,
        paymentId,
        const DeepCollectionEquality().hash(paymentWay),
        customerId,
        deliveryAddress,
        orderPhoneNumber,
        floorNumber,
        apartmentNumber,
        additionalInfo,
        pdfLink,
        roadId,
        orderMode,
        orderId,
        createBy,
        createdAt,
        updatedAt,
        deletedAt,
        statusName,
        zoneArea,
        postalCode,
        maxMaintenancePrice,
        paidAmount,
        paymentFile,
        pickupOrderRef,
        isAmountReceived,
        isCustomerConfirm,
        paymentMethod,
        orderVisitTime
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
      required final String? information,
      required final String address,
      required final String brand,
      required final String city,
      required final double lat,
      required final double lng,
      required final int status,
      required final int type,
      required final double? vat,
      required final double? subtotal,
      required final double? total,
      required final String? report,
      required final List<FilesModel>? files,
      required final UserModel customer,
      required final Guarantees? guarantee,
      required final List<Item>? items,
      required final List<Devices>? devices,
      required final List<Questions>? questions,
      @JsonKey(name: 'reference_no') required final String referenceNo,
      @JsonKey(name: 'driver_id') required final int? driverId,
      @JsonKey(name: 'problem_summary') required final String problemSummary,
      @JsonKey(name: 'type_name') required final String typeName,
      @JsonKey(name: 'maintenance_device')
      required final String maintenanceDevice,
      @JsonKey(name: 'is_paid') required final bool isPaid,
      @JsonKey(name: 'is_pickup') required final bool isPickup,
      @JsonKey(name: 'visit_time') required final String? visitTime,
      @JsonKey(name: 'payment_id') required final String? paymentId,
      @JsonKey(name: 'payment_way') required final dynamic paymentWay,
      @JsonKey(name: 'customer_id') required final int customerId,
      @JsonKey(name: 'pickupAddress')
      required final DeliveryAddress? deliveryAddress,
      @JsonKey(name: 'order_phone_number')
      required final String? orderPhoneNumber,
      @JsonKey(name: 'floor_number') required final int? floorNumber,
      @JsonKey(name: 'apartment_number') required final String? apartmentNumber,
      @JsonKey(name: 'additional_info') required final String? additionalInfo,
      @JsonKey(name: 'pdf_link') required final String pdfLink,
      @JsonKey(name: 'road_id') required final int? roadId,
      @JsonKey(name: 'order_mode') required final int? orderMode,
      @JsonKey(name: 'first_visit_id') required final int? orderId,
      @JsonKey(name: 'create_by') required final int createBy,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'deleted_at') required final DateTime? deletedAt,
      @JsonKey(name: 'status_name') required final String statusName,
      @JsonKey(name: 'zone_area') required final String? zoneArea,
      @JsonKey(name: 'postal_code') required final int postalCode,
      @JsonKey(name: 'max_maintenance_price')
      required final double? maxMaintenancePrice,
      @JsonKey(name: 'paid_amount') required final double? paidAmount,
      @JsonKey(name: 'payment_file') required final String? paymentFile,
      @JsonKey(name: 'pickup_order_ref') required final String? pickupOrderRef,
      @JsonKey(name: 'is_amount_received') required final bool isAmountReceived,
      @JsonKey(name: 'is_customer_confirm')
      required final bool isCustomerConfirm,
      @JsonKey(name: 'payment_method') required final String? paymentMethod,
      @JsonKey(name: 'order_visit_time')
      required final String? orderVisitTime}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  int get id;
  @override
  String? get information;
  @override
  String get address;
  @override
  String get brand;
  @override
  String get city;
  @override
  double get lat;
  @override
  double get lng;
  @override
  int get status;
  @override
  int get type;
  @override
  double? get vat;
  @override
  double? get subtotal;
  @override
  double? get total;
  @override
  String? get report;
  @override
  List<FilesModel>? get files;
  @override
  UserModel get customer;
  @override
  Guarantees? get guarantee;
  @override
  List<Item>? get items;
  @override
  List<Devices>? get devices;
  @override
  List<Questions>? get questions;
  @override
  @JsonKey(name: 'reference_no')
  String get referenceNo;
  @override
  @JsonKey(name: 'driver_id')
  int? get driverId;
  @override
  @JsonKey(name: 'problem_summary')
  String get problemSummary;
  @override
  @JsonKey(name: 'type_name')
  String get typeName;
  @override
  @JsonKey(name: 'maintenance_device')
  String get maintenanceDevice;
  @override
  @JsonKey(name: 'is_paid')
  bool get isPaid;
  @override
  @JsonKey(name: 'is_pickup')
  bool get isPickup;
  @override
  @JsonKey(name: 'visit_time')
  String? get visitTime;
  @override
  @JsonKey(name: 'payment_id')
  String? get paymentId;
  @override
  @JsonKey(name: 'payment_way')
  dynamic get paymentWay;
  @override
  @JsonKey(name: 'customer_id')
  int get customerId;
  @override
  @JsonKey(name: 'pickupAddress')
  DeliveryAddress? get deliveryAddress;
  @override
  @JsonKey(name: 'order_phone_number')
  String? get orderPhoneNumber;
  @override
  @JsonKey(name: 'floor_number')
  int? get floorNumber;
  @override
  @JsonKey(name: 'apartment_number')
  String? get apartmentNumber;
  @override
  @JsonKey(name: 'additional_info')
  String? get additionalInfo;
  @override
  @JsonKey(name: 'pdf_link')
  String get pdfLink;
  @override
  @JsonKey(name: 'road_id')
  int? get roadId;
  @override
  @JsonKey(name: 'order_mode')
  int? get orderMode;
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
  @JsonKey(name: 'zone_area')
  String? get zoneArea;
  @override
  @JsonKey(name: 'postal_code')
  int get postalCode;
  @override
  @JsonKey(name: 'max_maintenance_price')
  double? get maxMaintenancePrice;
  @override
  @JsonKey(name: 'paid_amount')
  double? get paidAmount;
  @override
  @JsonKey(name: 'payment_file')
  String? get paymentFile;
  @override
  @JsonKey(name: 'pickup_order_ref')
  String? get pickupOrderRef;
  @override
  @JsonKey(name: 'is_amount_received')
  bool get isAmountReceived;
  @override
  @JsonKey(name: 'is_customer_confirm')
  bool get isCustomerConfirm;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @JsonKey(name: 'order_visit_time')
  String? get orderVisitTime;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
mixin _$Item {
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemCopyWith<Item> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res, Item>;
  @useResult
  $Res call({int? id, String title, int quantity, double price});
}

/// @nodoc
class _$ItemCopyWithImpl<$Res, $Val extends Item>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemImplCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$$ItemImplCopyWith(
          _$ItemImpl value, $Res Function(_$ItemImpl) then) =
      __$$ItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String title, int quantity, double price});
}

/// @nodoc
class __$$ItemImplCopyWithImpl<$Res>
    extends _$ItemCopyWithImpl<$Res, _$ItemImpl>
    implements _$$ItemImplCopyWith<$Res> {
  __$$ItemImplCopyWithImpl(_$ItemImpl _value, $Res Function(_$ItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_$ItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemImpl implements _Item {
  const _$ItemImpl(
      {this.id,
      required this.title,
      required this.quantity,
      required this.price});

  factory _$ItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemImplFromJson(json);

  @override
  final int? id;
  @override
  final String title;
  @override
  final int quantity;
  @override
  final double price;

  @override
  String toString() {
    return 'Item(id: $id, title: $title, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, quantity, price);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      __$$ItemImplCopyWithImpl<_$ItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemImplToJson(
      this,
    );
  }
}

abstract class _Item implements Item {
  const factory _Item(
      {final int? id,
      required final String title,
      required final int quantity,
      required final double price}) = _$ItemImpl;

  factory _Item.fromJson(Map<String, dynamic> json) = _$ItemImpl.fromJson;

  @override
  int? get id;
  @override
  String get title;
  @override
  int get quantity;
  @override
  double get price;
  @override
  @JsonKey(ignore: true)
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) {
  return _DeliveryAddress.fromJson(json);
}

/// @nodoc
mixin _$DeliveryAddress {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  int? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  int? get postalCode => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get telephone => throw _privateConstructorUsedError;
  @JsonKey(name: 'part_of_building')
  String? get partOfBuilding => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeliveryAddressCopyWith<DeliveryAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryAddressCopyWith<$Res> {
  factory $DeliveryAddressCopyWith(
          DeliveryAddress value, $Res Function(DeliveryAddress) then) =
      _$DeliveryAddressCopyWithImpl<$Res, DeliveryAddress>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'order_id') int? orderId,
      @JsonKey(name: 'company_name') String? companyName,
      String? name,
      String? address,
      @JsonKey(name: 'postal_code') int? postalCode,
      String? phone,
      String? telephone,
      @JsonKey(name: 'part_of_building') String? partOfBuilding});
}

/// @nodoc
class _$DeliveryAddressCopyWithImpl<$Res, $Val extends DeliveryAddress>
    implements $DeliveryAddressCopyWith<$Res> {
  _$DeliveryAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? companyName = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? postalCode = freezed,
    Object? phone = freezed,
    Object? telephone = freezed,
    Object? partOfBuilding = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as int?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      telephone: freezed == telephone
          ? _value.telephone
          : telephone // ignore: cast_nullable_to_non_nullable
              as String?,
      partOfBuilding: freezed == partOfBuilding
          ? _value.partOfBuilding
          : partOfBuilding // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryAddressImplCopyWith<$Res>
    implements $DeliveryAddressCopyWith<$Res> {
  factory _$$DeliveryAddressImplCopyWith(_$DeliveryAddressImpl value,
          $Res Function(_$DeliveryAddressImpl) then) =
      __$$DeliveryAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'order_id') int? orderId,
      @JsonKey(name: 'company_name') String? companyName,
      String? name,
      String? address,
      @JsonKey(name: 'postal_code') int? postalCode,
      String? phone,
      String? telephone,
      @JsonKey(name: 'part_of_building') String? partOfBuilding});
}

/// @nodoc
class __$$DeliveryAddressImplCopyWithImpl<$Res>
    extends _$DeliveryAddressCopyWithImpl<$Res, _$DeliveryAddressImpl>
    implements _$$DeliveryAddressImplCopyWith<$Res> {
  __$$DeliveryAddressImplCopyWithImpl(
      _$DeliveryAddressImpl _value, $Res Function(_$DeliveryAddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderId = freezed,
    Object? companyName = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? postalCode = freezed,
    Object? phone = freezed,
    Object? telephone = freezed,
    Object? partOfBuilding = freezed,
  }) {
    return _then(_$DeliveryAddressImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as int?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      telephone: freezed == telephone
          ? _value.telephone
          : telephone // ignore: cast_nullable_to_non_nullable
              as String?,
      partOfBuilding: freezed == partOfBuilding
          ? _value.partOfBuilding
          : partOfBuilding // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryAddressImpl implements _DeliveryAddress {
  const _$DeliveryAddressImpl(
      {required this.id,
      @JsonKey(name: 'order_id') required this.orderId,
      @JsonKey(name: 'company_name') required this.companyName,
      required this.name,
      required this.address,
      @JsonKey(name: 'postal_code') required this.postalCode,
      required this.phone,
      required this.telephone,
      @JsonKey(name: 'part_of_building') required this.partOfBuilding});

  factory _$DeliveryAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryAddressImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'order_id')
  final int? orderId;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  final String? name;
  @override
  final String? address;
  @override
  @JsonKey(name: 'postal_code')
  final int? postalCode;
  @override
  final String? phone;
  @override
  final String? telephone;
  @override
  @JsonKey(name: 'part_of_building')
  final String? partOfBuilding;

  @override
  String toString() {
    return 'DeliveryAddress(id: $id, orderId: $orderId, companyName: $companyName, name: $name, address: $address, postalCode: $postalCode, phone: $phone, telephone: $telephone, partOfBuilding: $partOfBuilding)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.telephone, telephone) ||
                other.telephone == telephone) &&
            (identical(other.partOfBuilding, partOfBuilding) ||
                other.partOfBuilding == partOfBuilding));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderId, companyName, name,
      address, postalCode, phone, telephone, partOfBuilding);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryAddressImplCopyWith<_$DeliveryAddressImpl> get copyWith =>
      __$$DeliveryAddressImplCopyWithImpl<_$DeliveryAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryAddressImplToJson(
      this,
    );
  }
}

abstract class _DeliveryAddress implements DeliveryAddress {
  const factory _DeliveryAddress(
      {required final int? id,
      @JsonKey(name: 'order_id') required final int? orderId,
      @JsonKey(name: 'company_name') required final String? companyName,
      required final String? name,
      required final String? address,
      @JsonKey(name: 'postal_code') required final int? postalCode,
      required final String? phone,
      required final String? telephone,
      @JsonKey(name: 'part_of_building')
      required final String? partOfBuilding}) = _$DeliveryAddressImpl;

  factory _DeliveryAddress.fromJson(Map<String, dynamic> json) =
      _$DeliveryAddressImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'order_id')
  int? get orderId;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  String? get name;
  @override
  String? get address;
  @override
  @JsonKey(name: 'postal_code')
  int? get postalCode;
  @override
  String? get phone;
  @override
  String? get telephone;
  @override
  @JsonKey(name: 'part_of_building')
  String? get partOfBuilding;
  @override
  @JsonKey(ignore: true)
  _$$DeliveryAddressImplCopyWith<_$DeliveryAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
