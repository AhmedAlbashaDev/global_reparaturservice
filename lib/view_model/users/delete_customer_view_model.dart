import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/response_state.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';

final usersDeleteCustomerViewModelProvider = StateNotifierProvider<DeleteCustomerViewModel,ResponseState<UserModel>>((ref) {
  return DeleteCustomerViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class DeleteCustomerViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  DeleteCustomerViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> delete({required String endPoint}) async{

    state = const ResponseState<UserModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.delete(endPoint: endPoint);

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

}