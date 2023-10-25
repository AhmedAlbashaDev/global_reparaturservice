import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String? image,
    required String email,
    @JsonKey(name: 'email_verified_at',) required DateTime? emailVerifiedAt,
    required int? type,
    required String? address,
    @JsonKey(name: 'postal_code',) required String? postalCode,
    required String? city,
    required String? phone,
    required double? lat,
    required double? lng,
    @JsonKey(name: 'zone_area',) required String? zoneArea,
    @JsonKey(name: 'national_id',) required String? nationalId,
    @JsonKey(name: 'created_at',) required DateTime? createdAt,
    @JsonKey(name: 'updated_at',) required DateTime? updatedAt,
    @JsonKey(name: 'deleted_at',) required DateTime? deletedAt,
    required String? role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}