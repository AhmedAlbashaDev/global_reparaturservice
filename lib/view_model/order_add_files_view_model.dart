import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/file.dart';
import '../models/order.dart';
import '../models/response_state.dart';
import '../repositories/orders_respository.dart';

final orderFilesViewModelProvider = StateNotifierProvider.autoDispose<OrderFilesViewModel,ResponseState<FilesModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return OrderFilesViewModel(OrdersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class OrderFilesViewModel extends StateNotifier<ResponseState<FilesModel>> {
  final OrdersRepository ordersRepository;
  OrderFilesViewModel(this.ordersRepository) : super(const ResponseState<FilesModel>.idle());

  Future<void> addFiles({required int orderId ,required List<XFile?> files}) async{

    setState(const ResponseState<FilesModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.addFiles(orderId: orderId, files: files);

    response.whenOrNull(data: (data) {
      setState(ResponseState<FilesModel>.data(data: data));
    }, error: (error) {
      setState(ResponseState<FilesModel>.error(error: error));
    });
  }

  Future<void> deleteFile({required int orderId ,required int? fileId}) async{

    setState(const ResponseState<FilesModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.deleteFile(orderId: orderId, fileId: fileId);

    response.whenOrNull(success: (data) {
      setState(ResponseState<FilesModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<FilesModel>.error(error: error));
    });
  }

  setState(ResponseState<FilesModel> newState){
    if(mounted) {
      state = newState;
    }
  }

}