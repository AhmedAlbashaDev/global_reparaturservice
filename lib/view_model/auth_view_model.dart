import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

final authViewModelProvider = StateNotifierProvider.autoDispose<AuthViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return AuthViewModel(AuthRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class AuthViewModel extends StateNotifier<ResponseState<UserModel>>{
  final AuthRepository authRepository;

  AuthViewModel(this.authRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> loginAdmin({required String email, required String password}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    String? token = await FirebaseMessaging.instance.getToken();

    FormData data = FormData.fromMap({
      'email'     : email,
      'password'  : password,
      'fcm_token'  : token,
      'device_type'  : Platform.isAndroid ? 'android' : 'ios',
    });

    final response = await authRepository.login(endPoint: 'login', data: data);

    response.whenOrNull(data: (data) {
      state = ResponseState<UserModel>.data(data: data);
    }, error: (error) {
      state = ResponseState<UserModel>.error(error: error);
    });

  }

  Future<void> loginTechnician({required String phone, required String password}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    String? token = await FirebaseMessaging.instance.getToken();

    FormData data = FormData.fromMap({
      'phone'     : phone,
      'password'  : password,
      'fcm_token'  : token,
      'device_type'  : Platform.isAndroid ? 'android' : 'ios',
    });

    final response = await authRepository.login(endPoint: 'driver-login', data: data);

    response.whenOrNull(data: (data) {
      state = ResponseState<UserModel>.data(data: data);
    }, error: (error) {
      state = ResponseState<UserModel>.error(error: error);
    });

  }

  Future<void> logout() async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await authRepository.logout();

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

