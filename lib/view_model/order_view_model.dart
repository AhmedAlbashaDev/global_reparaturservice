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

  Future<void> loadOne({required int orderId}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.loadOne(endPoint: 'orders/$orderId');

    response.whenOrNull(data: (data) {
      setState(ResponseState<OrderModel>.data(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> create({required String maintenanceDevice ,required String brand ,required String description ,required String address ,required String floorNumber ,required String apartmentNumber ,required String additionalInfo ,required int? customerId , required double? lat , required double? lng , required String? phone}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.create(maintenanceDevice: maintenanceDevice, brand: brand, description: description, address: address, floorNumber: floorNumber, apartmentNumber: apartmentNumber, additionalInfo: additionalInfo, customerId: customerId, lat: lat, lng: lng , phone: phone);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
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

  Future<void> sendInvoice({required int orderId}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.sendInvoice(endPoint: 'orders/send-invoice/$orderId');

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'send_invoice' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> finishOrder({required int orderId ,required String report}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.update(
        orderId: orderId,
        data: {
          "report" : report,
          "status" : 3
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