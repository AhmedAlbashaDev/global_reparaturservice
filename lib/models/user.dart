import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String? name,
    required String? image,
    required String? email,
    @JsonKey(name: 'company_name',) required String? companyName,
    @JsonKey(name: 'email_verified_at',) required DateTime? emailVerifiedAt,
    required int? type,
    required String? address,
    @JsonKey(name: 'postal_code',) required int? postalCode,
    @JsonKey(name: 'part_of_building',) required String? partOfBuilding,
    required String? city,
    required String? phone,
    required String? telephone,
    required double? lat,
    required double? lng,
    @JsonKey(name: 'is_disabled') required bool? isDisabled,
    @JsonKey(name: 'zone_area',) required String? zoneArea,
    @JsonKey(name: 'national_id',) required String? nationalId,
    @JsonKey(name: 'created_at',) required DateTime? createdAt,
    @JsonKey(name: 'updated_at',) required DateTime? updatedAt,
    @JsonKey(name: 'deleted_at',) required DateTime? deletedAt,
    required String? role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}