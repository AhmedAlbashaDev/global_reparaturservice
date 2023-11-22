import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/repositories/users_repository.dart';
import 'package:global_reparaturservice/view_model/language_view_model.dart';

import '../core/providers/dio_network_provider.dart';
import '../core/providers/token_provider.dart';
import '../core/service/shared_preferences.dart';
import '../models/response_state.dart';
import '../models/user.dart';

final splashViewModelProvider = StateNotifierProvider.autoDispose<SplashViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return SplashViewModel(ref);
});

class SplashViewModel extends StateNotifier<ResponseState<UserModel>>{
  late UsersRepository usersRepository;
  final Ref ref;

  SplashViewModel(this.ref) : super(const ResponseState<UserModel>.idle());

  Future<String> checkAndGetLocalUser() async{

    final token  = await SharedPref.get('userToken');

    ref.read(tokenProvider.notifier).state = token;

    final savesLanguage = await ref.read(languageViewModelProvider.notifier).getLanguage();
    
    usersRepository = UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref);

    await Future.delayed(const Duration(seconds: 2));

    if(token != null){

      setState(const ResponseState<UserModel>.loading());

      await Future.delayed(const Duration(seconds: 1));

      final response = await usersRepository.loadLocalUer(endPoint: 'current-user');

      response.whenOrNull(data: (data) {
        state = ResponseState<UserModel>.data(data: data);
      }, error: (error) async {
        ref.read(tokenProvider.notifier).state = null;
        await SharedPref.clear();
        state = ResponseState<UserModel>.error(error: error);
      });
    }
    else{
      state = const ResponseState<UserModel>.success(data: {});
    }

    return savesLanguage;
  }

  setState(ResponseState<UserModel> newState){
    if(mounted) {
      state = newState;
    }
  }

}

