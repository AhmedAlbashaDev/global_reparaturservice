import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/repositories/users_repository.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/user.dart';

final updatePasswordViewModelProvider = StateNotifierProvider.autoDispose<UpdatePasswordViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return UpdatePasswordViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class UpdatePasswordViewModel extends StateNotifier<ResponseState<UserModel>> {
  final UsersRepository usersRepository;

  UpdatePasswordViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> updatePassword({required String password}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    FormData data = FormData.fromMap({
      'password'     : password,
    });

    final response = await usersRepository.updateProfile(endPoint: 'update-profile', data: data);

    response.whenOrNull(success: (data) {
      setState(ResponseState<UserModel>.success(data: data));
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