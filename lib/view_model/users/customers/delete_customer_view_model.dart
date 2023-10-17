import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_network_provider.dart';
import '../../../models/response_state.dart';
import '../../../models/user.dart';
import '../../../repositories/users_repository.dart';

final usersDeleteCustomerViewModelProvider = StateNotifierProvider.autoDispose<DeleteCustomerViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return DeleteCustomerViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class DeleteCustomerViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  DeleteCustomerViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> delete({required String endPoint}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.delete(endPoint: endPoint);

    response.whenOrNull(data: (data) {
      setState(ResponseState<UserModel>.data(data: data));
    }, error: (error) {
      setState(ResponseState<UserModel>.error(error: error));
    });
  }

  setState(ResponseState<UserModel> newState){
    if(mounted) {
      state = newState;
    }
  }

}