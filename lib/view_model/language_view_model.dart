import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/repositories/users_repository.dart';

import '../core/providers/dio_network_provider.dart';
import '../core/providers/token_provider.dart';
import '../core/service/shared_preferences.dart';
import '../models/response_state.dart';
import '../models/user.dart';

final languageViewModelProvider = StateNotifierProvider.autoDispose<LanguageViewModel,ResponseState<UserModel>>((ref) {
  return LanguageViewModel(ref);
});

class LanguageViewModel extends StateNotifier<ResponseState<UserModel>>{
  final Ref ref;

  LanguageViewModel(this.ref) : super(const ResponseState<UserModel>.idle());

  Future<void> changeLanguage(Locale local) async{
    await SharedPref.set('userLanguage', local.languageCode);
  }

  Future<String> getLanguage() async{

    final savedLanguage = await SharedPref.get('userLanguage');

    return savedLanguage ?? 'de';
  }

  setState(ResponseState<UserModel> newState){
    if(mounted) {
      state = newState;
    }
  }

}

