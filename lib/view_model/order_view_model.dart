import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/order.dart';
import '../models/response_state.dart';
import '../repositories/orders_respository.dart';

final orderViewModelProvider = StateNotifierProvider.autoDispose<OrderViewModel,ResponseState<OrderModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return OrderViewModel(OrdersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class OrderViewModel extends StateNotifier<ResponseState<OrderModel>> {
  final OrdersRepository ordersRepository;
   OrderViewModel(this.ordersRepository) : super(const ResponseState<OrderModel>.idle());

  Future<void> create({required String maintenanceDevice ,required String brand ,required String description ,required String address ,required String floorNumber ,required String apartmentNumber ,required String additionalInfo ,required int? customerId , required double? lat , required double? lng , required String? phone , required String? postalCode , required String? city , required String? zone , required String? visitTime}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    Map data = {
      'maintenance_device' : maintenanceDevice,
      'brand' : brand,
      'description' : description,
      'address' : address,
      'customer_id' : customerId,
      'lat' : lat,
      'lng' : lng,
      'city' : city,
      'postal_code' : postalCode,
      'zone' : zone,
      'floor_number' : floorNumber,
      'apartment_number' : apartmentNumber,
      'order_phone_number' : phone,
      'additional_info' : additionalInfo,
      "visit_time" : visitTime,
    };

    final response = await ordersRepository.create(endPoint: 'orders', data: data);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> dropOffOrder({required String referenceNumber ,required bool withRoute}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));


    final response = await ordersRepository.create(endPoint: 'orders/add-drop-off' ,data: {
      'reference_no' : referenceNumber,
      'with_route' : withRoute,
    });

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: {'with_route' : withRoute}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> updatePayment({required int orderId ,required String? paymentId , required int paymentWay}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.update(
      orderId: orderId,
      data: {
        "is_paid" : true,
        "payment_id" : paymentId,
        "payment_way" : paymentWay,
      },
    );

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> updateAmount({required int orderId ,required String? amount}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.update(
      orderId: orderId,
      data: {
        "amount" : amount,
      },
    );

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> updateOrderType({required int orderId ,required int? type}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.update(
      orderId: orderId,
      data: {
        "type" : type,
      },
    );

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> sendInvoice({required int orderId}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.sendInvoice(endPoint: 'orders/send-invoice/$orderId');

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'send_invoice' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> finishOrder({required int orderId ,required bool isPayLater}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.update(
        orderId: orderId,
        data: {
          "status" : 3,
          "is_pay_later" : isPayLater
        },
    );

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'finish_order' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> addFiles({required int id ,required List<PlatformFile?> files}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.addFiles(id: id, files: files);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> addReports({required int id ,required String title, required String description , required String price}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    Map data = {
      "title" : title,
      "description" : description,
      "price" : price
    };

    final response = await ordersRepository.addReport(id: id, data: data);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> deleteFile({required int id ,required int? fileId}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.deleteFile(id: id, fileId: fileId);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  setState(ResponseState<OrderModel> newState){
    if(mounted) {
      state = newState;
    }
  }

}