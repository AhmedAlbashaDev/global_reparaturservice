import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMachinesProvider = StateNotifierProvider<SelectedMachines , List<int>>((ref) => SelectedMachines());

class SelectedMachines extends StateNotifier<List<int>> {
  SelectedMachines() : super([]);

  addMachine ({required int machineId}){
      state = [...state, machineId];
  }

  removeMachine ({required int machineId}){
      state = state.where((id) => id != machineId).toList();
  }
}