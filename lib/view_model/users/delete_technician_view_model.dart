import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/dio_network_provider.dart';
import '../../models/response_state.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';

final usersDeleteTechnicianViewModelProvider = StateNotifierProvider<DeleteTechnicianViewModel,ResponseState<UserModel>>((ref) {
  return DeleteTechnicianViewModel(UsersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class DeleteTechnicianViewModel extends StateNotifier<ResponseState<UserModel>>{
  final UsersRepository usersRepository;

  DeleteTechnicianViewModel(this.usersRepository) : super(const ResponseState<UserModel>.idle());

  Future<void> delete({required String endPoint}) async{

    state = const ResponseState<UserModel>.loading();

    await Future.delayed(const Duration(seconds: 1));

    final response = await usersRepository.delete(endPoint: endPoint);

    response.whenOrNull(data: (data) {
      state = ResponseState.data(data: data);
    }, error: (error) {
      state = ResponseState.error(error: error);
    });
  }

}