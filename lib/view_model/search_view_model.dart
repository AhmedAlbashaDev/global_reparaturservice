import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/order.dart';
import '../models/pagination_model.dart';
import '../models/response_state.dart';
import '../models/routes.dart';
import '../models/user.dart';
import '../repositories/search_repository.dart';

final searchViewModelProvider = StateNotifierProvider.autoDispose<SearchViewModel,ResponseState>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return SearchViewModel(SearchRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref),ref);
});

class SearchViewModel extends StateNotifier<ResponseState>{
  late SearchRepository searchRepository;
  final Ref ref;

  SearchViewModel(this.searchRepository ,this.ref) : super(const ResponseState<UserModel>.idle());

  Future<void> search({required String endPoint , required String searchText , String? dateFrom , String? dateTo , bool withoutRoute = false}) async{

    state = const ResponseState.loading();

    await Future.delayed(const Duration(seconds: 1));

    String url = '';

    if(withoutRoute == true){
      url = '$endPoint?search_text=$searchText&per_page=10&without_route=$withoutRoute';
    }
    else if(dateTo != null && dateFrom != null){
      url = '$endPoint?search_text=$searchText&per_page=10&date_from=$dateFrom&date_to=$dateTo';
    }
    else{
      url = '$endPoint?search_text=$searchText&per_page=10';
    }

    final response = await searchRepository.search(endPoint: url);

    if(endPoint.contains('roads')){
      response.whenOrNull(data: (data) {
        state = ResponseState<PaginationModel<RoutesModel>>.data(data: data as PaginationModel<RoutesModel>);
      }, error: (error) {
        state = ResponseState<PaginationModel<RoutesModel>>.error(error: error);
      });
    }
    else if(endPoint.contains('orders')){
      response.whenOrNull(data: (data) {
        state = ResponseState<PaginationModel<OrderModel>>.data(data: data as PaginationModel<OrderModel>);
      }, error: (error) {
        state = ResponseState<PaginationModel<OrderModel>>.error(error: error);
      });
    }
    else {
      response.whenOrNull(data: (data) {
        state = ResponseState<PaginationModel<UserModel>>.data(data: data as PaginationModel<UserModel>);
      }, error: (error) {
        state = ResponseState<PaginationModel<UserModel>>.error(error: error);
      });
    }
  }

  Future<void> searchMore({required String endPoint , required String searchText ,required List oldList ,required int pageNumber ,String? dateFrom , String? dateTo , bool withoutRoute = false}) async{


    state = const ResponseState.loading();

    await Future.delayed(const Duration(seconds: 1));

    String url = '';

    if(withoutRoute == true){
      url = '$endPoint?search_text=$searchText&per_page=10&without_route=$withoutRoute&page=$pageNumber';
    }
    else if(dateTo != null && dateFrom != null){
      url = '$endPoint?search_text=$searchText&per_page=10&date_from=$dateFrom&date_to=$dateTo&page=$pageNumber';
    }
    else{
      url = '$endPoint?search_text=$searchText&per_page=10&page=$pageNumber';
    }

    final response = await searchRepository.search(endPoint: url);

    if(endPoint.contains('roads')){
      response.whenOrNull(data: (data) {
        /// Add old list in the beginning of the new list
        oldList.addAll(data.data);
        state = ResponseState<PaginationModel<RoutesModel>>.data(data: data.copyWith(data: oldList) as PaginationModel<RoutesModel>);
      }, error: (error) {
        state = ResponseState<PaginationModel<RoutesModel>>.error(error: error);
      });
    }
    else if(endPoint.contains('orders')){
      response.whenOrNull(data: (data) {
        /// Add old list in the beginning of the new list
        oldList.addAll(data.data);
        state = ResponseState<PaginationModel<OrderModel>>.data(data: data.copyWith(data: oldList) as PaginationModel<OrderModel>);
      }, error: (error) {
        state = ResponseState<PaginationModel<OrderModel>>.error(error: error);
      });
    }
    else {
      response.whenOrNull(data: (data) {
        /// Add old list in the beginning of the new list
        oldList.addAll(data.data);
        state = ResponseState<PaginationModel<UserModel>>.data(data: data.copyWith(data: oldList) as PaginationModel<UserModel>);
      }, error: (error) {
        state = ResponseState<PaginationModel<UserModel>>.error(error: error);
      });
    }
  }
}

