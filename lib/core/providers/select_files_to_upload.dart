import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedFilesToUpload = StateNotifierProvider.autoDispose<SelectedFilesToUpload , List<PlatformFile?>>((ref) => SelectedFilesToUpload());

class SelectedFilesToUpload extends StateNotifier<List<PlatformFile>> {
  SelectedFilesToUpload() : super([]);


  int get length {
    return state.length;
  }

  addFiles (PlatformFile? platformFile){
    if(platformFile != null){
      state = [...state, platformFile];
    }
  }

  removeFiles (PlatformFile? platformFile){
    if(platformFile != null){
      state = state.where((file) => file.path != platformFile.path).toList();
    }
  }

}