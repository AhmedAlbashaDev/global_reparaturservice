import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/order.dart';
import '../models/response_state.dart';
import '../repositories/orders_respository.dart';

final loadOrderViewModelProvider = StateNotifierProvider.autoDispose<OrderViewModel,ResponseState<OrderModel>>((ref) {
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

  setState(ResponseState<OrderModel> newState){
    if(mounted) {
      state = newState;
    }
  }

}