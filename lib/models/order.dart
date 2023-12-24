import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:global_reparaturservice/models/devices.dart';
import 'package:global_reparaturservice/models/file.dart';
import 'package:global_reparaturservice/models/guarantees.dart';
import 'package:global_reparaturservice/models/questions.dart';
import 'package:global_reparaturservice/models/user.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required int id,
    required String? information,
    required String address,
    required String brand,
    required String city,
    required double lat,
    required double lng,
    required int status,
    required int type,
    required double? vat,
    required double? subtotal,
    required double? total,
    required String? report,
    required List<FilesModel>? files,
    required UserModel customer,
    required Guarantees? guarantee,
    required List<Item>? items,
    required List<Devices>? devices,
    required List<Questions>? questions,
    @JsonKey(name: 'reference_no') required String referenceNo,
    @JsonKey(name: 'driver_id') required int? driverId,
    @JsonKey(name: 'problem_summary') required String problemSummary,
    @JsonKey(name: 'type_name') required String typeName,
    @JsonKey(name: 'maintenance_device') required String maintenanceDevice,
    @JsonKey(name: 'is_paid') required bool isPaid,
    @JsonKey(name: 'is_pickup') required bool isPickup,
    @JsonKey(name: 'visit_time') required String? visitTime,
    @JsonKey(name: 'payment_id') required String? paymentId,
    @JsonKey(name: 'payment_way') required dynamic paymentWay,
    @JsonKey(name: 'customer_id') required int customerId,
    @JsonKey(name: 'pickupAddress') required DeliveryAddress? deliveryAddress,
    @JsonKey(name: 'order_phone_number') required String? orderPhoneNumber,
    @JsonKey(name: 'floor_number') required int? floorNumber,
    @JsonKey(name: 'apartment_number') required String? apartmentNumber,
    @JsonKey(name: 'additional_info') required String? additionalInfo,
    @JsonKey(name: 'pdf_link') required String pdfLink,
    @JsonKey(name: 'road_id') required int? roadId,
    @JsonKey(name: 'order_mode') required int? orderMode,
    @JsonKey(name: 'first_visit_id') required int? orderId,
    @JsonKey(name: 'create_by') required int createBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') required DateTime? deletedAt,
    @JsonKey(name: 'status_name') required String statusName,
    @JsonKey(name: 'zone_area') required String? zoneArea,
    @JsonKey(name: 'postal_code') required int postalCode,
    @JsonKey(name: 'max_maintenance_price') required double? maxMaintenancePrice,
    @JsonKey(name: 'paid_amount') required double? paidAmount,
    @JsonKey(name: 'payment_file') required String? paymentFile,
    @JsonKey(name: 'pickup_order_ref') required String? pickupOrderRef,
    @JsonKey(name: 'is_amount_received') required bool isAmountReceived,
    @JsonKey(name: 'is_customer_confirm') required bool isCustomerConfirm,
    @JsonKey(name: 'payment_method') required String? paymentMethod,
    @JsonKey(name: 'order_visit_time') required String? orderVisitTime,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}

@freezed
class Item with _$Item {
  const factory Item({
    int? id,
    required String title,
    required int quantity,
    required double price,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
class DeliveryAddress with _$DeliveryAddress {
  const factory DeliveryAddress({
    required int? id,
    @JsonKey(name: 'order_id') required int? orderId,
    @JsonKey(name: 'company_name') required String? companyName,
    required String? name,
    required String? address,
    @JsonKey(name: 'postal_code') required int? postalCode,
    required String? phone,
    required String? telephone,
    @JsonKey(name: 'part_of_building') required String? partOfBuilding,
  }) = _DeliveryAddress;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => _$DeliveryAddressFromJson(json);
}