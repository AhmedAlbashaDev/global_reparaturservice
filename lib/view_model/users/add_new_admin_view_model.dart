import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/response_state.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';

final usersAddNewAdminViewModelProvider = StateNotifierProvider<AddNewAdminViewModel,ResponseState<UserModel>>((ref) {
  return AddNewAdminViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class AddNewAdminViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  AddNewAdminViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> create({required String endPoint , required String name , required String email, required String password, required String additional,}) async{

    state = const ResponseState<UserModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    FormData data = FormData.fromMap({
      'name' : name,
      'email' : email,
      'password' : password,
      'additional_info' : additional,
    });

    final response = await usersRepository.create(endPoint: endPoint, data: data);

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

}