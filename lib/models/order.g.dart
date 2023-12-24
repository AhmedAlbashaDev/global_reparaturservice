// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as int,
      information: json['information'] as String?,
      address: json['address'] as String,
      brand: json['brand'] as String,
      city: json['city'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'] as int,
      type: json['type'] as int,
      vat: (json['vat'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      report: json['report'] as String?,
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FilesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customer: UserModel.fromJson(json['customer'] as Map<String, dynamic>),
      guarantee: json['guarantee'] == null
          ? null
          : Guarantees.fromJson(json['guarantee'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      devices: (json['devices'] as List<dynamic>?)
          ?.map((e) => Devices.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Questions.fromJson(e as Map<String, dynamic>))
          .toList(),
      referenceNo: json['reference_no'] as String,
      driverId: json['driver_id'] as int?,
      problemSummary: json['problem_summary'] as String,
      typeName: json['type_name'] as String,
      maintenanceDevice: json['maintenance_device'] as String,
      isPaid: json['is_paid'] as bool,
      isPickup: json['is_pickup'] as bool,
      visitTime: json['visit_time'] as String?,
      paymentId: json['payment_id'] as String?,
      paymentWay: json['payment_way'],
      customerId: json['customer_id'] as int,
      deliveryAddress: json['pickupAddress'] == null
          ? null
          : DeliveryAddress.fromJson(
              json['pickupAddress'] as Map<String, dynamic>),
      orderPhoneNumber: json['order_phone_number'] as String?,
      floorNumber: json['floor_number'] as int?,
      apartmentNumber: json['apartment_number'] as String?,
      additionalInfo: json['additional_info'] as String?,
      pdfLink: json['pdf_link'] as String,
      roadId: json['road_id'] as int?,
      orderMode: json['order_mode'] as int?,
      orderId: json['first_visit_id'] as int?,
      createBy: json['create_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      statusName: json['status_name'] as String,
      zoneArea: json['zone_area'] as String?,
      postalCode: json['postal_code'] as int,
      maxMaintenancePrice: (json['max_maintenance_price'] as num?)?.toDouble(),
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      paymentFile: json['payment_file'] as String?,
      pickupOrderRef: json['pickup_order_ref'] as String?,
      isAmountReceived: json['is_amount_received'] as bool,
      isCustomerConfirm: json['is_customer_confirm'] as bool,
      paymentMethod: json['payment_method'] as String?,
      orderVisitTime: json['order_visit_time'] as String?,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'information': instance.information,
      'address': instance.address,
      'brand': instance.brand,
      'city': instance.city,
      'lat': instance.lat,
      'lng': instance.lng,
      'status': instance.status,
      'type': instance.type,
      'vat': instance.vat,
      'subtotal': instance.subtotal,
      'total': instance.total,
      'report': instance.report,
      'files': instance.files,
      'customer': instance.customer,
      'guarantee': instance.guarantee,
      'items': instance.items,
      'devices': instance.devices,
      'questions': instance.questions,
      'reference_no': instance.referenceNo,
      'driver_id': instance.driverId,
      'problem_summary': instance.problemSummary,
      'type_name': instance.typeName,
      'maintenance_device': instance.maintenanceDevice,
      'is_paid': instance.isPaid,
      'is_pickup': instance.isPickup,
      'visit_time': instance.visitTime,
      'payment_id': instance.paymentId,
      'payment_way': instance.paymentWay,
      'customer_id': instance.customerId,
      'pickupAddress': instance.deliveryAddress,
      'order_phone_number': instance.orderPhoneNumber,
      'floor_number': instance.floorNumber,
      'apartment_number': instance.apartmentNumber,
      'additional_info': instance.additionalInfo,
      'pdf_link': instance.pdfLink,
      'road_id': instance.roadId,
      'order_mode': instance.orderMode,
      'first_visit_id': instance.orderId,
      'create_by': instance.createBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'status_name': instance.statusName,
      'zone_area': instance.zoneArea,
      'postal_code': instance.postalCode,
      'max_maintenance_price': instance.maxMaintenancePrice,
      'paid_amount': instance.paidAmount,
      'payment_file': instance.paymentFile,
      'pickup_order_ref': instance.pickupOrderRef,
      'is_amount_received': instance.isAmountReceived,
      'is_customer_confirm': instance.isCustomerConfirm,
      'payment_method': instance.paymentMethod,
      'order_visit_time': instance.orderVisitTime,
    };

_$ItemImpl _$$ItemImplFromJson(Map<String, dynamic> json) => _$ItemImpl(
      id: json['id'] as int?,
      title: json['title'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'quantity': instance.quantity,
      'price': instance.price,
    };

_$DeliveryAddressImpl _$$DeliveryAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$DeliveryAddressImpl(
      id: json['id'] as int?,
      orderId: json['order_id'] as int?,
      companyName: json['company_name'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      postalCode: json['postal_code'] as int?,
      phone: json['phone'] as String?,
      telephone: json['telephone'] as String?,
      partOfBuilding: json['part_of_building'] as String?,
    );

Map<String, dynamic> _$$DeliveryAddressImplToJson(
        _$DeliveryAddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'company_name': instance.companyName,
      'name': instance.name,
      'address': instance.address,
      'postal_code': instance.postalCode,
      'phone': instance.phone,
      'telephone': instance.telephone,
      'part_of_building': instance.partOfBuilding,
    };
