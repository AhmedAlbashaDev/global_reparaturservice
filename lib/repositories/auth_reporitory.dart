import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

      ref.read(tokenProvider.notifier).state = response.data['data']['token'];

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response.data['data']['user']));

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

}
