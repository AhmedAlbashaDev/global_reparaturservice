// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilesModelImpl _$$FilesModelImplFromJson(Map<String, dynamic> json) =>
    _$FilesModelImpl(
      id: json['id'] as int,
      pathName: json['path_name'] as String,
      fileName: json['file_name'] as String,
      fullPath: json['full_path'] as String,
    );

Map<String, dynamic> _$$FilesModelImplToJson(_$FilesModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path_name': instance.pathName,
      'file_name': instance.fileName,
      'full_path': instance.fullPath,
    };
