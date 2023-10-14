import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';

import '../core/custom_exception.dart';
import '../models/pagination_model.dart';
import '../models/response_state.dart';

class OrdersRepository {
  OrdersRepository({required this.dioClient, required this.ref});

  final Dio dioClient;
  final Ref ref;

  Future<ResponseState<PaginationModel<OrderModel>>> loadAll({required String endPoint}) async {
    try {

      final response = await dioClient.get(endPoint);

      if(response.data['success'] == false){
        return ResponseState<PaginationModel<OrderModel>>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      PaginationModel<OrderModel> paginationModel = PaginationModel<OrderModel>.fromJson(response.data['data']);

      List<OrderModel> list = [];

      for(final json in response.data['data']['data']){
        list.add(OrderModel.fromJson(json));
      }

      return ResponseState<PaginationModel<OrderModel>>.data(data: paginationModel.copyWith(data: list));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<PaginationModel<OrderModel>>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<PaginationModel<OrderModel>>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<OrderModel>> loadOne({required String endPoint}) async {
    try {

      final response = await dioClient.get(endPoint);

      if(response.data['success'] == false){
        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<OrderModel>.data(data: OrderModel.fromJson(response.data['data']));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<OrderModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<OrderModel>> create({required String maintenanceDevice ,required String brand ,required String description ,required String address ,required String floorNumber ,required String apartmentNumber ,required String additionalInfo ,required int? customerId , required double? lat , required double? lng , required String? phone}) async {
    try {

      FormData data = FormData.fromMap({
        'maintenance_device' : maintenanceDevice,
        'brand' : brand,
        'description' : description,
        'address' : address,
        'customer_id' : customerId,
        'lat' : lat,
        'lng' : lng,
        'city' : '',
        'floor_number' : floorNumber,
        'apartment_number' : apartmentNumber,
        'order_phone_number' : phone,
        'additional_info' : additionalInfo,
      });

      final response = await dioClient.post('orders' , data: data);

      if(response.data['success'] == false){
        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return const ResponseState<OrderModel>.success(data: {});

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<OrderModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }



}