
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/devices.dart';
import 'package:global_reparaturservice/repositories/general_repositroy.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';

final getDevicesViewModelProvider = StateNotifierProvider<GetDevicesViewModel,ResponseState<List<Devices>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return GetDevicesViewModel(GeneralRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class GetDevicesViewModel extends StateNotifier<ResponseState<List<Devices>>> {
  final GeneralRepository generalRepository;
  GetDevicesViewModel(this.generalRepository) : super(const ResponseState<List<Devices>>.idle());

  Future<void> getDevices() async{

    setState(const ResponseState<List<Devices>>.loading());

    final response = await generalRepository.getDevices();

    response.whenOrNull(
        data: (data) {
          setState(ResponseState<List<Devices>>.data(data: data));
        },
        error: (error) {
          setState(ResponseState<List<Devices>>.error(error: error));
        }
    );
  }

  setState(ResponseState<List<Devices>> newState){
    if(mounted) {
      state = newState;
    }
  }

}