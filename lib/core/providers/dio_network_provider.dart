import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'token_provider.dart';

/// DIO NETWORK PROVIDER

final dioClientNetworkProvider = Provider<Dio>((ref) {

  final token = ref.watch(tokenProvider);

  final Dio dio = Dio(BaseOptions(
      baseUrl: 'https://workshop.anothercars.com/api/',
      headers: {
        HttpHeaders.authorizationHeader : token != null ? 'Bearer $token' : null
      }
  ));

  ref.onDispose(() => dio.close);

  return dio..interceptors.addAll([LogInterceptor(responseBody: true, requestBody: true)]);
}, name: 'Dio');
