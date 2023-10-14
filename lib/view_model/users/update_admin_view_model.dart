import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/response_state.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';

final usersUpdateAdminViewModelProvider = StateNotifierProvider<UpdateAdminViewModel,ResponseState<UserModel>>((ref) {
  return UpdateAdminViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class UpdateAdminViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  UpdateAdminViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> update({required String endPoint , required String name , required String email, required String password, required String additional,}) async{

    state = const ResponseState<UserModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.update(endPoint: endPoint, data: {
      'name' : name,
      'email' : email,
      'password' : password,
      'Additional_info' : '',
    });

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

}