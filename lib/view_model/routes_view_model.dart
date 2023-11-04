import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/routes.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/pagination_model.dart';
import '../../models/response_state.dart';
import '../repositories/routes_repository.dart';

final todayRoutesViewModelProvider = StateNotifierProvider.autoDispose<RoutesViewModel,ResponseState<PaginationModel<RoutesModel>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return RoutesViewModel(RoutesRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

final routesViewModelProvider = StateNotifierProvider.autoDispose<RoutesViewModel,ResponseState<PaginationModel<RoutesModel>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return RoutesViewModel(RoutesRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class RoutesViewModel extends StateNotifier<ResponseState<PaginationModel<RoutesModel>>>{
  final RoutesRepository routesRepository;

  RoutesViewModel(this.routesRepository) : super(const ResponseState<PaginationModel<RoutesModel>>.loading());

  Future<void> loadAll({bool? today}) async{

    setState(const ResponseState<PaginationModel<RoutesModel>>.loading());

    await Future.delayed(const Duration(seconds: 1));

    String endPoint = "";

    if(today == true){
      endPoint = 'roads?today=true';
    }
    else{
      endPoint = 'roads';
    }

    final response = await routesRepository.loadAll(endPoint: endPoint);

    response.whenOrNull(data: (data) {
      setState(ResponseState<PaginationModel<RoutesModel>>.data(data: data));
    }, error: (error) {
      setState(ResponseState<PaginationModel<RoutesModel>>.error(error: error));
    });
  }

  Future<void> loadMore({required int pageNumber ,required List<RoutesModel> oldList}) async{

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