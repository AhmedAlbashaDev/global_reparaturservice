import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';

final addedItemsToOrderProvider = StateNotifierProvider<AddedItemsToOrder , List<Item>>((ref) => AddedItemsToOrder());

class AddedItemsToOrder extends StateNotifier<List<Item>> {
  AddedItemsToOrder() : super([]);

  addItem ({required Item item}){
    state = [...state, item];
  }

  removeItem ({required Item item}){
    state = state.where((element) => element != item).toList();
  }
}