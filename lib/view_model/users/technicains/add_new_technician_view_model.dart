import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/dio_network_provider.dart';
import '../../../models/response_state.dart';
import '../../../models/user.dart';
import '../../../repositories/users_repository.dart';

final usersAddNewTechnicianViewModelProvider = StateNotifierProvider.autoDispose<AddNewTechnicianViewModel,ResponseState<UserModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return AddNewTechnicianViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class AddNewTechnicianViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  AddNewTechnicianViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> create({required String endPoint , required String name, required String password, required String phoneNo, required String zoneArea, required String address, required String additional,}) async{

    setState(const ResponseState<UserModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    FormData data = FormData.fromMap({
      'name' : name,
      'phone' : phoneNo,
      'password' : password,
      'address' : address,
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