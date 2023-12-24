import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/models/user.dart';

part 'routes.freezed.dart';
part 'routes.g.dart';


@freezed
class RoutesModel with _$RoutesModel {
  const factory RoutesModel({
    required int id,
    @JsonKey(name: 'reference_no') required String referenceNo,
    @JsonKey(name: 'create_by') required int createBy,
    @JsonKey(name: 'driver_id') required int? driverId,
    required int status,
    required UserModel? driver,
    @JsonKey(name: 'status_name') required String statusName,
    List<OrderModel>? orders,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at')  required DateTime? deletedAt,

  }) = _RoutesModel;

  factory RoutesModel.fromJson(Map<String, dynamic> json) => _$RoutesModelFromJson(json);
}