import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';

final selectedOrdersToNewOrder = StateNotifierProvider.autoDispose<SelectedOrdersState , List<OrderModel?>>((ref) => SelectedOrdersState());

class SelectedOrdersState extends StateNotifier<List<OrderModel>> {
  SelectedOrdersState() : super([]);


  int get length {
    return state.length;
  }

  addOrder (OrderModel? orderModel){
    if(orderModel != null){
      state = [...state, orderModel];
    }
  }

  removeOrder (OrderModel? orderModel){
    state = state.where((order) => order.id != orderModel?.id).toList();
  }

}