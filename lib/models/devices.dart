import 'package:freezed_annotation/freezed_annotation.dart';

part 'devices.freezed.dart';
part 'devices.g.dart';

@freezed
class Devices with _$Devices {
  const factory Devices({
    required int id,
    required String name,
  }) = _Devices;

  factory Devices.fromJson(Map<String, dynamic> json) => _$DevicesFromJson(json);
}