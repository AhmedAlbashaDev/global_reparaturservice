import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

final forgetEmailViewModelProvider = StateNotifierProvider.autoDispose<ForgetPasswordViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ForgetPasswordViewModel(AuthRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class ForgetPasswordViewModel extends StateNotifier<ResponseState<UserModel>> {
  final AuthRepository authRepository;

  ForgetPasswordViewModel(this.authRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> forgetPassword({required String email}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    FormData data = FormData.fromMap({
      'email'     : email,
    });

    final response = await authRepository.forgetPassword(data: data);

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