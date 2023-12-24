import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:image_picker/image_picker.dart';

import '../core/custom_exception.dart';
import '../core/providers/request_sending_progress.dart';
import '../models/file.dart';
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

      List<OrderModel> data = [];

      for(final json in response.data['data']['data']){
        data.add(OrderModel.fromJson(json));
      }

      return ResponseState<PaginationModel<OrderModel>>.data(data: paginationModel.copyWith(data: data));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
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
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
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

  Future<ResponseState<List<String>>> getAvailableTimes({required String selectedDate}) async {
    try {

      final response = await dioClient.get('orders/available/time', queryParameters: {
        "selected_date": selectedDate
      });

      if(response.data['success'] == false){
        return ResponseState<List<String>>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      List<String> availableTimes = [];

      for(final availableTime in response.data['data']){
        availableTimes.add(availableTime);
      }

      return ResponseState<List<String>>.data(data: availableTimes);

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<List<String>>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<List<String>>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<OrderModel>> create({required String endPoint , Map? data}) async {
    try {

      final response = await dioClient.post(endPoint, data: data);

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
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<OrderModel>.error(
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

        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode:  e.response?.data['code'],
            errorMessage:     message.isEmpty ? e.response?.data['message'] : message,
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

  Future<ResponseState<OrderModel>> update({required int orderId , required Map<String , dynamic> data}) async {
    try {

      final response = await dioClient.put('orders/$orderId' , data: data);

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
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<OrderModel>.error(
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

        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode:  e.response?.data['code'],
            errorMessage:     message.isEmpty ? e.response?.data['message'] : message,
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

  Future<ResponseState<FilesModel>> addFiles({required int orderId, required List<XFile?> files,}) async {
    try {

      FormData data = FormData();

      for(final file in files){
        data.files.add(MapEntry('files[]', await MultipartFile.fromFile('${file?.path}' , filename: file?.name)));
      }


      final response = await dioClient.post(
          'orders/add-files/$orderId',
          data: data,
          onSendProgress: (sent , total) async{
            final progress = (sent / total * 100).toInt();
            ref.read(sendingRequestProgress.notifier).state = progress;
          }
      );

      if(response.data['success'] == false){
        return ResponseState<FilesModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<FilesModel>.data(data: FilesModel.fromJson(response.data['data']));

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<FilesModel>.error(
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

        return ResponseState<FilesModel>.error(
          error: CustomException(
            errorStatusCode:  e.response?.data['code'],
            errorMessage:     message.isEmpty ? e.response?.data['message'] : message,
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<FilesModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<FilesModel>> deleteFile({required int orderId, required int? fileId,}) async {
    try {

      final response = await dioClient.delete(
        'orders/delete-files/$orderId',
        data: {
          'file_id' : fileId
        },
      );

      if(response.data['success'] == false){
        return ResponseState<FilesModel>.error(
          error: CustomException(
            errorStatusCode: response.data['code'],
            errorMessage:    response.data['message'] ?? 'unknown_error_please_try_again'.tr(),
            errorType: DioExceptionType.unknown.name,
          ),
        );
      }

      return ResponseState<FilesModel>.success(data: response.data['data']);

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<FilesModel>.error(
          error: CustomException(
            errorStatusCode:  500,
            errorMessage:     'unknown_error_please_try_again'.tr(),
            errorType:        e.type.name,
          ),
        );
      }
      return ResponseState<FilesModel>.error(
        error: CustomException(
          errorStatusCode:  e.response?.data['code'],
          errorMessage:     e.response?.data['message'] ?? 'unknown_error_please_try_again'.tr(),
          errorType:        e.type.name,
        ),
      );
    }
  }

  Future<ResponseState<OrderModel>> addItem({required int orderId,required Map data}) async {
    try {

      final response = await dioClient.post(
          'orders/add-item/$orderId',
          data: data,
      );

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
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<OrderModel>.error(
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

        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode:  e.response?.data['code'],
            errorMessage:     message.isEmpty ? e.response?.data['message'] : message,
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

  Future<ResponseState<OrderModel>> deleteItem({required int orderId, required int? itemId,}) async {
    try {

      final response = await dioClient.delete(
        'orders/delete-item/$orderId',
        data: {
          'item_id' : itemId
        },
      );

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
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
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


  Future<ResponseState<OrderModel>> sendInvoice({required String endPoint}) async {
    try {

      final response = await dioClient.post(endPoint);

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
      if(e.type == DioExceptionType.badResponse && e.response?.data == null){
        return ResponseState<OrderModel>.error(
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

        return ResponseState<OrderModel>.error(
          error: CustomException(
            errorStatusCode:  e.response?.data['code'],
            errorMessage:     message.isEmpty ? e.response?.data['message'] : message,
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