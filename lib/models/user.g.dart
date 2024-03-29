// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as int,
      name: json['name'] as String?,
      image: json['image'] as String?,
      email: json['email'] as String?,
      companyName: json['company_name'] as String?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      type: json['type'] as int?,
      address: json['address'] as String?,
      postalCode: json['postal_code'] as int?,
      partOfBuilding: json['part_of_building'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      telephone: json['telephone'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      isDisabled: json['is_disabled'] as bool?,
      zoneArea: json['zone_area'] as String?,
      nationalId: json['national_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      role: json['role'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'email': instance.email,
      'company_name': instance.companyName,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'type': instance.type,
      'address': instance.address,
      'postal_code': instance.postalCode,
      'part_of_building': instance.partOfBuilding,
      'city': instance.city,
      'phone': instance.phone,
      'telephone': instance.telephone,
      'lat': instance.lat,
      'lng': instance.lng,
      'is_disabled': instance.isDisabled,
      'zone_area': instance.zoneArea,
      'national_id': instance.nationalId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'role': instance.role,
    };
