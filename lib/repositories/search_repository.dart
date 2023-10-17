

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:global_reparaturservice/models/user.dart';

import '../core/custom_exception.dart';
import '../models/pagination_model.dart';
import '../models/response_state.dart';

class SearchRepository {
  SearchRepository({required this.dioClient, required this.ref});

  final Dio dioClient;
  final Ref ref;


  Future<ResponseState<PaginationModel>> search({required String endPoint}) async {
    try {

      final response = await dioClient.get(endPoint);

      if(response.data['success'] == false){
        return ResponseState<PaginationModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      if(endPoint.contains('roads')){
        PaginationModel<RoutesModel> paginationModel = PaginationModel.fromJson(response.data['data']);

        List<RoutesModel> list = [];

        for(final json in response.data['data']['data']){
          list.add(RoutesModel.fromJson(json));
        }

        return ResponseState<PaginationModel<RoutesModel>>.data(data: paginationModel.copyWith(data: list));
      }
      else if(endPoint.contains('orders')){
        PaginationModel<OrderModel> paginationModel = PaginationModel.fromJson(response.data['data']);

        List<OrderModel> list = [];

        for(final json in response.data['data']['data']){
          list.add(OrderModel.fromJson(json));
        }

        return ResponseState<PaginationModel<OrderModel>>.data(data: paginationModel.copyWith(data: list));
      }
      else {
        PaginationModel<UserModel> paginationModel = PaginationModel.fromJson(response.data['data']);

        List<UserModel> list = [];

        for(final json in response.data['data']['data']){
          list.add(UserModel.fromJson(json));
        }

        return ResponseState<PaginationModel<UserModel>>.data(data: paginationModel.copyWith(data: list));
      }

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<PaginationModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<PaginationModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }
}