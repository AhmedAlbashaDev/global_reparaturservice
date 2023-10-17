import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:global_reparaturservice/models/file.dart';
import 'package:global_reparaturservice/models/user.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required int id,
    @JsonKey(name: 'reference_no') required String referenceNo,
    required String address,
    required String description,
    required String lat,
    required String lng,
    required int status,
    @JsonKey(name: 'maintenance_device') required String maintenanceDevice,
    required String? brand,
    @JsonKey(name: 'block_no') required String? blockNo,
    @JsonKey(name: 'is_paid') required bool isPaid,
    required String? amount,
    required String? report,
    @JsonKey(name: 'payment_id') required String? paymentId,
    @JsonKey(name: 'payment_way') required dynamic paymentWay,
    @JsonKey(name: 'customer_id') required int customerId,
    @JsonKey(name: 'order_phone_number') required String? orderPhoneNumber,
    @JsonKey(name: 'floor_number') required String? floorNumber,
    @JsonKey(name: 'apartment_number') required String? apartmentNumber,
    @JsonKey(name: 'additional_info') required String? additionalInfo,
    required UserModel? customer,
    required List<FilesModel>? files,
    @JsonKey(name: 'road_id') required int? roadId,
    @JsonKey(name: 'is_visit') required bool isVisit,
    @JsonKey(name: 'first_visit_id') required int? orderId,
    @JsonKey(name: 'create_by') required int createBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') required DateTime? deletedAt,
    @JsonKey(name: 'status_name') required String statusName,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}