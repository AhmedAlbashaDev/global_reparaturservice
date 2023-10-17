import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'file.freezed.dart';
part 'file.g.dart';

FilesModel filesModelFromJson(String str) => FilesModel.fromJson(json.decode(str));

String filesModelToJson(FilesModel data) => json.encode(data.toJson());

@freezed
class FilesModel with _$FilesModel {
  const factory FilesModel({
    required int id,
    @JsonKey(name: 'path_name') required String pathName,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'full_path') required String fullPath,
  }) = _FilesModel;

  factory FilesModel.fromJson(Map<String, dynamic> json) => _$FilesModelFromJson(json);
}