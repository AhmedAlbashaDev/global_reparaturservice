import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/routes.dart';
import '../repositories/routes_repository.dart';

final routeViewModelProvider = StateNotifierProvider<RouteViewModel,ResponseState<RoutesModel>>((ref) {
  return RouteViewModel(RoutesRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class RouteViewModel extends StateNotifier<ResponseState<RoutesModel>> {
  final RoutesRepository routesRepository;

  RouteViewModel(this.routesRepository) : super(const ResponseState<RoutesModel>.loading());

  Future<void> loadOne({required int routeId}) async{

    state = const ResponseState<RoutesModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await routesRepository.loadOne(endPoint: 'roads/$routeId');

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

  Future<void> create({required String description,required int? driverId,required List<OrderModel?> orders}) async {


    state = const ResponseState<RoutesModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    List<int?> ordersIDs = [];

    for (var order in orders) {
      ordersIDs.add(order?.id);
    }

    final response = await routesRepository.create(description: description, driverId: driverId, ordersIDs: ordersIDs);

    response.whenOrNull(success: (data) {
      state = ResponseState.success(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }


}