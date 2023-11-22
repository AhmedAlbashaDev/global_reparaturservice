
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/providers/token_provider.dart';
import 'package:global_reparaturservice/core/providers/user_provider.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

final logoutViewModelProvider = StateNotifierProvider.autoDispose<LogoutViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return LogoutViewModel(AuthRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref) , ref);
});

class LogoutViewModel extends StateNotifier<ResponseState<UserModel>>{
  final AuthRepository authRepository;
  Ref? ref;

  LogoutViewModel(this.authRepository , this.ref) : super(const ResponseState<UserModel>.idle());

  Future<void> logout() async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await authRepository.logout();

    ref?.read(tokenProvider.notifier).state = null;
    ref?.read(userProvider.notifier).state = null;

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

