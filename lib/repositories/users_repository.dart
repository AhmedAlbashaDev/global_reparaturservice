import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_reparaturservice/models/pagination_model.dart';

import '../core/custom_exception.dart';
import '../core/service/shared_preferences.dart';
import '../models/response_state.dart';
import '../models/user.dart';

class UsersRepository {
  UsersRepository({this.dioClient, this.ref});

  Dio? dioClient;
  final Ref? ref;

  Future<ResponseState<PaginationModel<UserModel>>> loadAll({required String endPoint}) async {
    try {

      final response = await dioClient?.get(endPoint);

      if(response?.data['success'] == false){
        return ResponseState<PaginationModel<UserModel>>.error(
          error: CustomException(
            errorStatusCode: response?.data['code'],
            errorMessage: response?.data['message'],
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      PaginationModel<UserModel> paginationModel = PaginationModel<UserModel>.fromJson(response?.data['data']);

      List<UserModel> list = [];

      for(final json in response?.data['data']['data']){
        list.add(UserModel.fromJson(json));
      }

      return ResponseState<PaginationModel<UserModel>>.data(data: paginationModel.copyWith(data: list));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
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

  Future<ResponseState<UserModel>> loadLocalUer({required String endPoint}) async {
    try {

      final response = await dioClient?.get(endPoint);

      if(response?.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response?.data['code'],
            errorMessage: response?.data['message'],
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response?.data['data']));

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
          errorMessage:     e.response?.data['message'],
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<UserModel>> create({required String endPoint ,required FormData data}) async {
    try {

      final response = await dioClient?.post(endPoint , data: data);

      if(response?.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response?.data['code'],
            errorMessage: response?.data['message'],
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response?.data['data']));

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
          errorMessage:     e.response?.data['message'],
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<UserModel>> update({required String endPoint , data}) async {
    try {

      final response = await dioClient?.put(endPoint , data: data);

      if(response?.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response?.data['code'],
            errorMessage: response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }


      return ResponseState<UserModel>.data(data: UserModel.fromJson(response?.data['data']));

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

  Future<ResponseState<UserModel>> updateProfile({required String endPoint , data}) async {
    try {

      final response = await dioClient?.post(endPoint , data: data);

      if(response?.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response?.data['code'],
            errorMessage: response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
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

  Future<void> updateLocation() async {


    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final token = await SharedPref.get('userToken');

    dioClient = Dio(BaseOptions(
        baseUrl: 'https://smart-intercom.de/api/',
        headers: {
          HttpHeaders.authorizationHeader : token != null ? 'Bearer $token' : null,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
    ));

    dioClient?.interceptors.addAll([LogInterceptor(responseBody: true, requestBody: true)]);

      await dioClient?.post('drivers/update-location' , data: {
        'lat' : position.latitude,
        'lng' : position.longitude,
      });

  }

  Future<ResponseState<UserModel>> delete({required String endPoint}) async {
    try {

      final response = await dioClient?.delete(endPoint);

      if(response?.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response?.data['code'],
            errorMessage: response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response?.data['data']));

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
          errorMessage:     e.response?.data['message'],
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<UserModel>> enable({required String endPoint}) async {
    try {

      final response = await dioClient?.post(endPoint);

      if(response?.data['success'] == false){
        return ResponseState<UserModel>.error(
          error: CustomException(
            errorStatusCode: response?.data['code'],
            errorMessage: response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<UserModel>.data(data: UserModel.fromJson(response?.data['data']));

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
          errorMessage:     e.response?.data['message'],
          errorType:        e.type.name,
        ),
      );
    }
  }

}