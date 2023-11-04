import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'app_locale.dart';
import 'token_provider.dart';

/// DIO NETWORK PROVIDER

final dioClientNetworkProvider = Provider.autoDispose<Dio>((ref) {

  final token = ref.watch(tokenProvider);

  final Dio dio = Dio(BaseOptions(
      // baseUrl: 'https://workshop.anothercars.com/api/',
      baseUrl: 'https://smart-intercom.de/api/',
      headers: {
        HttpHeaders.authorizationHeader : token != null ? 'Bearer $token' : null,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language' : ref.watch(currentAppLocaleProvider).name.toString(),
      }
  ));

  ref.onDispose(() => dio.close);

  return dio..interceptors.addAll([
    LogInterceptor(responseBody: true, requestBody: true)]);
}, name: 'Dio');