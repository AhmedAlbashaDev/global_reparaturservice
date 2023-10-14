import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:global_reparaturservice/repositories/users_repository.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/pagination_model.dart';
import '../../models/response_state.dart';


final usersAdminsViewModelProvider = StateNotifierProvider<UsersViewModel,ResponseState<PaginationModel<UserModel>>>((ref) {
  return UsersViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

final usersTechniciansViewModelProvider = StateNotifierProvider<UsersViewModel,ResponseState<PaginationModel<UserModel>>>((ref) {
  return UsersViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

final usersCustomersViewModelProvider = StateNotifierProvider<UsersViewModel,ResponseState<PaginationModel<UserModel>>>((ref) {
  return UsersViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});



class UsersViewModel extends StateNotifier<ResponseState<PaginationModel<UserModel>>>{
  final UsersRepository usersRepository;

  UsersViewModel(this.usersRepository) : super(const ResponseState<PaginationModel<UserModel>>.loading());

  Future<void> loadAll({required String endPoint}) async{

    state = const ResponseState<PaginationModel<UserModel>>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.loadAll(endPoint: endPoint);

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

  Future<void> loadMore({required String endPoint , required int pageNumber ,required List<UserModel> oldList}) async{

    state = const ResponseState<PaginationModel<UserModel>>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.loadAll(endPoint: '$endPoint?page=$pageNumber');

    response.whenOrNull(data: (data) {
      /// Add old list in the beginning of the new list
      oldList.addAll(data.data);

      state = ResponseState<PaginationModel<UserModel>>.data(data: data.copyWith(data: oldList));
    }, error: (error) {
      state = ResponseState.error(error: error);
    });

  }

}