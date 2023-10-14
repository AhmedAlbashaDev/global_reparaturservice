// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoutesModelImpl _$$RoutesModelImplFromJson(Map<String, dynamic> json) =>
    _$RoutesModelImpl(
      id: json['id'] as int,
      description: json['description'] as String,
      referenceNo: json['reference_no'] as String,
      createBy: json['create_by'] as int,
      driverId: json['driver_id'] as int?,
      status: json['status'] as int,
      statusName: json['status_name'] as String,
      driver: json['driver'] == null
          ? null
          : UserModel.fromJson(json['driver'] as Map<String, dynamic>),
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$$RoutesModelImplToJson(_$RoutesModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'reference_no': instance.referenceNo,
      'create_by': instance.createBy,
      'driver_id': instance.driverId,
      'status': instance.status,
      'status_name': instance.statusName,
      'driver': instance.driver,
      'orders': instance.orders,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
