import 'package:freezed_annotation/freezed_annotation.dart';

part 'guarantees.freezed.dart';
part 'guarantees.g.dart';

@freezed
class Guarantees with _$Guarantees {
  const factory Guarantees({
    required int id,
    required String name,
  }) = _Guarantees;

  factory Guarantees.fromJson(Map<String, dynamic> json) => _$GuaranteesFromJson(json);
}