import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../repositories/orders_respository.dart';

final orderGetAvailableTimesViewModelProvider = StateNotifierProvider.autoDispose<OrderAvailableTimesViewModel,ResponseState<List<String>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return OrderAvailableTimesViewModel(OrdersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class OrderAvailableTimesViewModel extends StateNotifier<ResponseState<List<String>>> {
  final OrdersRepository ordersRepository;
  OrderAvailableTimesViewModel(this.ordersRepository) : super(const ResponseState<List<String>>.idle());

  Future<void> getAvailableTimes({required String? selectedDate}) async{

    setState(const ResponseState<List<String>>.loading());

    final response = await ordersRepository.getAvailableTimes(selectedDate:selectedDate!);

    response.whenOrNull(
      data: (data) {
        setState(ResponseState<List<String>>.data(data: data));
      },
      error: (error) {
        setState(ResponseState<List<String>>.error(error: error));
      }
    );
  }

  setState(ResponseState<List<String>> newState){
    if(mounted) {
      state = newState;
    }
  }

}