import 'package:freezed_annotation/freezed_annotation.dart';

part 'questions.freezed.dart';
part 'questions.g.dart';

@freezed
class Questions with _$Questions {
  const factory Questions({
    required int id,
    required String name,
  }) = _Questions;

  factory Questions.fromJson(Map<String, dynamic> json) => _$QuestionsFromJson(json);
}