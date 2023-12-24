import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/devices.dart';

import '../core/custom_exception.dart';
import '../models/guarantees.dart';
import '../models/questions.dart';
import '../models/response_state.dart';

class GeneralRepository {
  GeneralRepository({required this.dioClient, required this.ref});

  final Dio dioClient;
  final Ref ref;


  Future<ResponseState<List<Devices>>> getDevices() async {
    try {

      final response = await dioClient.get('devices');

      if(response.data['success'] == false){
        return ResponseState<List<Devices>>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      List<Devices> devices = [];

      for(final json in response.data['data']){
        devices.add(Devices.fromJson(json));
      }

      return ResponseState<List<Devices>>.data(data: devices);

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<List<Devices>>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<List<Devices>>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<List<Questions>>> getQuestions() async {
    try {

      final response = await dioClient.get('questions');

      if(response.data['success'] == false){
        return ResponseState<List<Questions>>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      List<Questions> devices = [];

      for(final json in response.data['data']){
        devices.add(Questions.fromJson(json));
      }

      return ResponseState<List<Questions>>.data(data: devices);

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<List<Questions>>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<List<Questions>>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<List<Guarantees>>> getGuarantees() async {
    try {

      final response = await dioClient.get('guarantees');

      if(response.data['success'] == false){
        return ResponseState<List<Guarantees>>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      List<Guarantees> devices = [];

      for(final json in response.data['data']){
        devices.add(Guarantees.fromJson(json));
      }

      return ResponseState<List<Guarantees>>.data(data: devices);

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<List<Guarantees>>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<List<Guarantees>>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }


}