import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/service/shared_preferences.dart';

import '../core/custom_exception.dart';
import '../core/providers/token_provider.dart';
import '../models/response_state.dart';
import '../models/user.dart';

class AuthRepository {
  AuthRepository({required this.dioClient, required this.ref});

  final Dio dioClient;
  final Ref ref;

  Future<ResponseState<UserModel>> login({required FormData data}) async {
    try {

      final response = await dioClient.post('login', data: data);

      if(response.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      final token = response.data['data']['token'];

      ref.read(tokenProvider.notifier).state = token;


      UserModel userModel = UserModel.fromJson(response.data['data']['user']);

      await SharedPref.set('userToken' , token);
      await SharedPref.set('userType' , userModel.role ?? '');

      return ResponseState<UserModel>.data(data: userModel);

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      else if (e.response?.statusCode == 422){

        String message = '';

        for(final key in (e.response?.data['data'] as Map<String , dynamic>).entries){
          message += '${key.value[0]} , ';
        }

        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode:  e.response?.data['code'],
            errorMessage:     message.isEmpty ? e.response?.data['message'] : message,
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

  Future<ResponseState<UserModel>> forgetPassword({required FormData data}) async {
    try {

      final response = await dioClient.post('forget-password', data: data);

      if(response.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return const ResponseState<UserModel>.success(data: {});

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      else if (e.response?.statusCode == 422){

        String message = '';

        for(final key in (e.response?.data['data'] as Map<String , dynamic>).entries){
          message += '${key.value[0]} , ';
        }

        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode:  e.response?.data['code'],
            errorMessage:     message.isEmpty ? e.response?.data['message'] : message,
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

  Future<ResponseState<UserModel>> logout() async {
    try {

      final response = await dioClient.post('logout');

      if(response.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      SharedPref.clear();

      return const ResponseState<UserModel>.success(data: {});

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
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

}
