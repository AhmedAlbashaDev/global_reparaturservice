// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as int,
      referenceNo: json['reference_no'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'] as int,
      type: json['type'] as int,
      typeName: json['type_name'] as String,
      maintenanceDevice: json['maintenance_device'] as String,
      brand: json['brand'] as String?,
      blockNo: json['block_no'] as String?,
      isPaid: json['is_paid'] as bool,
      amount: json['amount'] as int?,
      reports: (json['reports'] as List<dynamic>?)
          ?.map((e) => Reports.fromJson(e as Map<String, dynamic>))
          .toList(),
      visitTime: json['visit_time'] as String?,
      paymentId: json['payment_id'] as String?,
      paymentWay: json['payment_way'],
      customerId: json['customer_id'] as int,
      orderPhoneNumber: json['order_phone_number'] as String?,
      floorNumber: json['floor_number'] as int?,
      apartmentNumber: json['apartment_number'] as String?,
      additionalInfo: json['additional_info'] as String?,
      pdfLink: json['pdf_link'] as String,
      customer: json['customer'] == null
          ? null
          : UserModel.fromJson(json['customer'] as Map<String, dynamic>),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FilesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      roadId: json['road_id'] as int?,
      isVisit: json['is_visit'] as bool,
      orderId: json['first_visit_id'] as int?,
      createBy: json['create_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      statusName: json['status_name'] as String,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference_no': instance.referenceNo,
      'address': instance.address,
      'description': instance.description,
      'lat': instance.lat,
      'lng': instance.lng,
      'status': instance.status,
      'type': instance.type,
      'type_name': instance.typeName,
      'maintenance_device': instance.maintenanceDevice,
      'brand': instance.brand,
      'block_no': instance.blockNo,
      'is_paid': instance.isPaid,
      'amount': instance.amount,
      'reports': instance.reports,
      'visit_time': instance.visitTime,
      'payment_id': instance.paymentId,
      'payment_way': instance.paymentWay,
      'customer_id': instance.customerId,
      'order_phone_number': instance.orderPhoneNumber,
      'floor_number': instance.floorNumber,
      'apartment_number': instance.apartmentNumber,
      'additional_info': instance.additionalInfo,
      'pdf_link': instance.pdfLink,
      'customer': instance.customer,
      'files': instance.files,
      'road_id': instance.roadId,
      'is_visit': instance.isVisit,
      'first_visit_id': instance.orderId,
      'create_by': instance.createBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'status_name': instance.statusName,
    };

_$ReportsImpl _$$ReportsImplFromJson(Map<String, dynamic> json) =>
    _$ReportsImpl(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
    );

Map<String, dynamic> _$$ReportsImplToJson(_$ReportsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
    };
