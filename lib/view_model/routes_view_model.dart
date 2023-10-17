import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/routes.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/pagination_model.dart';
import '../../models/response_state.dart';
import '../repositories/routes_repository.dart';

final routesViewModelProvider = StateNotifierProvider.autoDispose<RoutesViewModel,ResponseState<PaginationModel<RoutesModel>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return RoutesViewModel(RoutesRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class RoutesViewModel extends StateNotifier<ResponseState<PaginationModel<RoutesModel>>>{
  final RoutesRepository routesRepository;

  RoutesViewModel(this.routesRepository) : super(const ResponseState<PaginationModel<RoutesModel>>.loading());

  Future<void> loadAll() async{

    setState(const ResponseState<PaginationModel<RoutesModel>>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await routesRepository.loadAll(endPoint: 'roads');

    response.whenOrNull(data: (data) {
      setState(ResponseState<PaginationModel<RoutesModel>>.data(data: data));
    }, error: (error) {
      setState(ResponseState<PaginationModel<RoutesModel>>.error(error: error));
    });
  }

  Future<void> loadMore({required int pageNumber ,required List<RoutesModel> oldList}) async{

    setState(const ResponseState<PaginationModel<RoutesModel>>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await routesRepository.loadAll(endPoint: 'roads?page=$pageNumber');

    response.whenOrNull(data: (data) {
      /// Add old list in the beginning of the new list
      oldList.addAll(data.data);
      setState(ResponseState<PaginationModel<RoutesModel>>.data(data: data.copyWith(data: oldList)));
    }, error: (error) {
      setState((ResponseState<PaginationModel<RoutesModel>>.error(error: error)));
    });
  }

  setState(ResponseState<PaginationModel<RoutesModel>> newState){
    if(mounted) {
      state = newState;
    }
  }

}