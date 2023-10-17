import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_network_provider.dart';
import '../../../models/response_state.dart';
import '../../../models/user.dart';
import '../../../repositories/users_repository.dart';

final usersUpdateCustomerViewModelProvider = StateNotifierProvider.autoDispose<UpdateCustomerViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return UpdateCustomerViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class UpdateCustomerViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  UpdateCustomerViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> update({required String endPoint , required String name , required String email, required String address, required String phone, required String zoneArea, required String additional,}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.update(endPoint: endPoint, data: {
      'name' : name,
      'email' : email,
      'address' : address,
      'zone_area' : zoneArea,
    });

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