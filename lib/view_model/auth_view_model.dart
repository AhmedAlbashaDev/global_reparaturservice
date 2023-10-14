import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/user.dart';
import '../repositories/auth_reporitory.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel,ResponseState<UserModel>>((ref) {
  return AuthViewModel(AuthRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class AuthViewModel extends StateNotifier<ResponseState<UserModel>>{
  final AuthRepository authRepository;

  AuthViewModel(this.authRepository) : super(const ResponseState.idle());

  Future<void> login({required String email, required String password}) async{

    state = const ResponseState.loading();

    await Future.delayed(const Duration(seconds: 1));

    String? token = await FirebaseMessaging.instance.getToken();

    FormData data = FormData.fromMap({
      'email'     : email,
      'password'  : password,
      'fcm_token'  : token,
      'device_type'  : Platform.isAndroid ? 'android' : 'ios',
    });

    final response = await authRepository.login(data: data);

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });

  }
}

