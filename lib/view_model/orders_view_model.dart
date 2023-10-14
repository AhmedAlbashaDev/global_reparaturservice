import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/pagination_model.dart';
import '../../models/response_state.dart';
import '../models/order.dart';
import '../repositories/orders_respository.dart';

final ordersViewModelProvider = StateNotifierProvider<OrdersViewModel,ResponseState<PaginationModel<OrderModel>>>((ref) {
  return OrdersViewModel(OrdersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class OrdersViewModel extends StateNotifier<ResponseState<PaginationModel<OrderModel>>>{
  final OrdersRepository usersRepository;

  OrdersViewModel(this.usersRepository) : super(const ResponseState<PaginationModel<OrderModel>>.loading());

  Future<void> loadAll({bool? pendingOrdersOnly}) async{

    state = const ResponseState<PaginationModel<OrderModel>>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.loadAll(endPoint: pendingOrdersOnly ?? false ? 'orders?without_route=true' : 'orders');

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

  Future<void> loadMore({required int pageNumber ,required List<OrderModel> oldList}) async{

    state = const ResponseState<PaginationModel<OrderModel>>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.loadAll(endPoint: 'orders?page=$pageNumber');

    response.whenOrNull(data: (data) {
      /// Add old list in the beginning of the new list
      oldList.addAll(data.data);

      state = ResponseState<PaginationModel<OrderModel>>.data(data: data.copyWith(data: oldList));
    }, error: (error) {
      state = ResponseState.error(error: error);
    });

  }

}