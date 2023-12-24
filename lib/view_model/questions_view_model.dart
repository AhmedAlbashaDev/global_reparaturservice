
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/repositories/general_repositroy.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/questions.dart';
import '../models/response_state.dart';

final getQuestionsViewModelProvider = StateNotifierProvider<GetQuestionsViewModel,ResponseState<List<Questions>>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return GetQuestionsViewModel(GeneralRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class GetQuestionsViewModel extends StateNotifier<ResponseState<List<Questions>>> {
  final GeneralRepository generalRepository;
  GetQuestionsViewModel(this.generalRepository) : super(const ResponseState<List<Questions>>.idle());

  Future<void> getQuestions() async{

    setState(const ResponseState<List<Questions>>.loading());

    final response = await generalRepository.getQuestions();

    response.whenOrNull(
        data: (data) {
          setState(ResponseState<List<Questions>>.data(data: data));
        },
        error: (error) {
          setState(ResponseState<List<Questions>>.error(error: error));
        }
    );
  }

  setState(ResponseState<List<Questions>> newState){
    if(mounted) {
      state = newState;
    }
  }

}