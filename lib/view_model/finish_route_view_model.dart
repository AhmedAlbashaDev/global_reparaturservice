import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/routes.dart';
import '../repositories/routes_repository.dart';
import '../view/screens/bottom_menu/routes/route_details_technician_map.dart';

final finishRouteViewModelProvider =
    StateNotifierProvider.autoDispose<FinishRouteViewModel, ResponseState<RoutesModel>>(
        (ref) {
          final cancelToken = CancelToken();
          ref.onDispose(cancelToken.cancel);
  return FinishRouteViewModel(
      RoutesRepository(dioClient: ref.read(dioClientNetworkProvider), ref: ref)
      , ref.read);
});

class FinishRouteViewModel extends StateNotifier<ResponseState<RoutesModel>> {
  FinishRouteViewModel(this.routesRepository, this.reader)
      : super(const ResponseState<RoutesModel>.loading());

  final RoutesRepository routesRepository;
  final dynamic reader;

  Future<void> finishRoute(
      {required int? routeId}) async {

    setState(const ResponseState<RoutesModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await routesRepository.update(
      routeId: routeId,
      data: {
        'status' : 3
      },
    );

    response.whenOrNull(success: (data) {
      reader(isFinishedRouteProvider.notifier).state = true;
      setState(ResponseState<RoutesModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<RoutesModel>.error(error: error));
    });
  }

  setState(ResponseState<RoutesModel> newState){
    if(mounted) {
      state = newState;
    }
  }
}
