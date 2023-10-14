import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/order.dart';
import '../models/response_state.dart';
import '../repositories/orders_respository.dart';

final orderViewModelProvider = StateNotifierProvider<OrderViewModel,ResponseState<OrderModel>>((ref) {
  return OrderViewModel(OrdersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class OrderViewModel extends StateNotifier<ResponseState<OrderModel>> {
  final OrdersRepository ordersRepository;
   OrderViewModel(this.ordersRepository) : super(const ResponseState<OrderModel>.loading());

  Future<void> loadOne({required int orderId}) async{

    state = const ResponseState<OrderModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.loadOne(endPoint: 'orders/$orderId');

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

  Future<void> create({required String maintenanceDevice ,required String brand ,required String description ,required String address ,required String floorNumber ,required String apartmentNumber ,required String additionalInfo ,required int? customerId , required double? lat , required double? lng , required String? phone}) async{

    state = const ResponseState<OrderModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.create(maintenanceDevice: maintenanceDevice, brand: brand, description: description, address: address, floorNumber: floorNumber, apartmentNumber: apartmentNumber, additionalInfo: additionalInfo, customerId: customerId, lat: lat, lng: lng , phone: phone);

    response.whenOrNull(success: (data) {
      state = ResponseState.success(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

}