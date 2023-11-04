import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:global_reparaturservice/repositories/users_repository.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/pagination_model.dart';
import '../../models/response_state.dart';

final usersAdminsViewModelProvider = StateNotifierProvider<UsersViewModel,ResponseState<PaginationModel<UserModel>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return UsersViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

final usersTechniciansViewModelProvider = StateNotifierProvider<UsersViewModel,ResponseState<PaginationModel<UserModel>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return UsersViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

final usersCustomersViewModelProvider = StateNotifierProvider<UsersViewModel,ResponseState<PaginationModel<UserModel>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return UsersViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});


class UsersViewModel extends StateNotifier<ResponseState<PaginationModel<UserModel>>>{
  final UsersRepository usersRepository;

  List<UserModel>? get users {
    return state.whenOrNull(
      data: (usersPag){
        return usersPag.data;
      }
    );
  }

  UsersViewModel(this.usersRepository) : super(const ResponseState<PaginationModel<UserModel>>.loading());

  Future<void> loadAll({required String endPoint}) async{

    setState(const ResponseState<PaginationModel<UserModel>>.loading());//rOLUUPUh

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.loadAll(endPoint: endPoint);

    response.whenOrNull(data: (data) {
      setState(ResponseState<PaginationModel<UserModel>>.data(data: data));
    }, error: (error) {
      setState(ResponseState<PaginationModel<UserModel>>.error(error: error));
    });
  }

  Future<void> loadMore({required String endPoint , required int pageNumber ,required List<UserModel> oldList}) async{

    final response = await usersRepository.loadAll(endPoint: '$endPoint?page=$pageNumber');

    response.whenOrNull(data: (data) {
      /// Add old list in the beginning of the new list
      oldList.addAll(data.data);

      setState(ResponseState<PaginationModel<UserModel>>.data(data: data.copyWith(data: oldList)));
    }, error: (error) {
      setState(ResponseState<PaginationModel<UserModel>>.error(error: error));
    });

  }

    setState(ResponseState<PaginationModel<UserModel>> newState){
      if(mounted) {
        state = newState;
      }
    }

}