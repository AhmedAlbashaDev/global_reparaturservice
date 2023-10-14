import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/pagination_model.dart';

import '../core/custom_exception.dart';
import '../models/response_state.dart';
import '../models/user.dart';

class UsersRepository {
  UsersRepository({required this.dioClient, required this.ref});

  final Dio dioClient;
  final Ref ref;

  Future<ResponseState<PaginationModel<UserModel>>> loadAll({required String endPoint}) async {
    try {

      final response = await dioClient.get(endPoint);

      if(response.data['success'] == false){
        return ResponseState<PaginationModel<UserModel>>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage: response.data['message'],
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      PaginationModel<UserModel> paginationModel = PaginationModel<UserModel>.fromJson(response.data['data']);

      List<UserModel> list = [];

      for(final json in response.data['data']['data']){
        list.add(UserModel.fromJson(json));
      }

      return ResponseState<PaginationModel<UserModel>>.data(data: paginationModel.copyWith(data: list));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<PaginationModel<UserModel>>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<PaginationModel<UserModel>>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'],
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<UserModel>> create({required String endPoint ,required FormData data}) async {
    try {

      final response = await dioClient.post(endPoint , data: data);

      if(response.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage: response.data['message'],
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response.data['data']));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<UserModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'],
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<UserModel>> update({required String endPoint , data}) async {
    try {

      final response = await dioClient.put(endPoint , data: data);

      if(response.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage: response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response.data['data']));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<UserModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<UserModel>> delete({required String endPoint}) async {
    try {

      final response = await dioClient.delete(endPoint);

      if(response.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage: response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response.data['data']));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<UserModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'],
          errorType:        e.type.name,
        ),
      );
    }
  }


}