import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final selectedFilesToUpload = StateNotifierProvider.autoDispose<SelectedFilesToUpload , List<XFile?>>((ref) => SelectedFilesToUpload());

class SelectedFilesToUpload extends StateNotifier<List<XFile>> {
  SelectedFilesToUpload() : super([]);


  int get length {
    return state.length;
  }

  addFiles (XFile? xFile){
    if(xFile != null){
      state = [...state, xFile];
    }
  }

  removeFiles (XFile? xFile){
    if(xFile != null){
      state = state.where((file) => file.path != xFile.path).toList();
    }
  }

}