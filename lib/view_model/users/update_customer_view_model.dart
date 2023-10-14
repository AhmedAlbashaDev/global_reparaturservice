import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/response_state.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';

final usersUpdateCustomerViewModelProvider = StateNotifierProvider<UpdateCustomerViewModel,ResponseState<UserModel>>((ref) {
  return UpdateCustomerViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class UpdateCustomerViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  UpdateCustomerViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> update({required String endPoint , required String name , required String email, required String address, required String phone, required String zoneArea, required String additional,}) async{

    state = const ResponseState<UserModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    print('Name is $name');
    print('Email is $email');

    FormData data = FormData.fromMap({
      'name' : name,
      'email' : email,
      'address' : address,
      'zone_area' : zoneArea,
    });

    final response = await usersRepository.update(endPoint: endPoint, data: {
      'name' : name,
      'email' : email,
      'address' : address,
      'zone_area' : zoneArea,
    });

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

}