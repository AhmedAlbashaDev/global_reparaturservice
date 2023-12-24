
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/repositories/general_repositroy.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/guarantees.dart';
import '../models/response_state.dart';

final getGuaranteesViewModelProvider = StateNotifierProvider<GetGuaranteesViewModel,ResponseState<List<Guarantees>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return GetGuaranteesViewModel(GeneralRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class GetGuaranteesViewModel extends StateNotifier<ResponseState<List<Guarantees>>> {
  final GeneralRepository generalRepository;
  GetGuaranteesViewModel(this.generalRepository) : super(const ResponseState<List<Guarantees>>.idle());

  Future<void> getGuarantees() async{

    setState(const ResponseState<List<Guarantees>>.loading());

    final response = await generalRepository.getGuarantees();

    response.whenOrNull(
        data: (data) {
          setState(ResponseState<List<Guarantees>>.data(data: data));
        },
        error: (error) {
          setState(ResponseState<List<Guarantees>>.error(error: error));
        }
    );
  }

  setState(ResponseState<List<Guarantees>> newState){
    if(mounted) {
      state = newState;
    }
  }

}