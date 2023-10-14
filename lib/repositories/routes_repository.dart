import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/custom_exception.dart';
import '../models/pagination_model.dart';
import '../models/response_state.dart';
import '../models/routes.dart';

class RoutesRepository {
  RoutesRepository({required this.dioClient, required this.ref});

  final Dio dioClient;
  final Ref ref;

  Future<ResponseState<PaginationModel<RoutesModel>>> loadAll({required String endPoint}) async {
    try {

      final response = await dioClient.get(endPoint);

      if(response.data['success'] == false){
        return ResponseState<PaginationModel<RoutesModel>>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      PaginationModel<RoutesModel> paginationModel = PaginationModel<RoutesModel>.fromJson(response.data['data']);

      List<RoutesModel> list = [];

      for(final json in response.data['data']['data']){
        list.add(RoutesModel.fromJson(json));
      }

      return ResponseState<PaginationModel<RoutesModel>>.data(data: paginationModel.copyWith(data: list));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<PaginationModel<RoutesModel>>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<PaginationModel<RoutesModel>>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<RoutesModel>> loadOne({required String endPoint}) async {
    try {

      final response = await dioClient.get(endPoint);

      if(response.data['success'] == false){
        return ResponseState<RoutesModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<RoutesModel>.data(data: RoutesModel.fromJson(response.data['data']));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<RoutesModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<RoutesModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<RoutesModel>> create({required String description,required int? driverId,required List<int?> ordersIDs}) async {
    try {

      FormData data = FormData.fromMap({
        'description' : description,
        'driver_id' : driverId,
        'orders_ids[]' : ordersIDs,
      });

      print('Data is ${data.fields}');

      final response = await dioClient.post('roads' , data: data);

      if(response.data['success'] == false){
        return ResponseState<RoutesModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return const ResponseState<RoutesModel>.success(data: {});

    } on DioException catch (e) {
      print('request data ${e.requestOptions.data}');
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<RoutesModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<RoutesModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }


}