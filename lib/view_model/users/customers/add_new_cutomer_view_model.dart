import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_network_provider.dart';
import '../../../models/response_state.dart';
import '../../../models/user.dart';
import '../../../repositories/users_repository.dart';

final usersAddNewCustomerViewModelProvider = StateNotifierProvider.autoDispose<AddNewCustomerViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return AddNewCustomerViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class AddNewCustomerViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  AddNewCustomerViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> create({required String endPoint , required String name , required String email, required String phoneNo, required String address, required String postalCode, required String city, required String zoneArea, required String additional,}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    FormData data = FormData.fromMap({
      'name' : name,
      'email' : email,
      'phone' : phoneNo,
      'address' : address,
      'postal_code' : postalCode,
      'city' : city,
      'zone_area' : zoneArea,
      'additional_info' : '',
    });

    final response = await usersRepository.create(endPoint: endPoint, data: data);

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