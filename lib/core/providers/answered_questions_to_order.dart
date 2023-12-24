import 'package:flutter_riverpod/flutter_riverpod.dart';

final answeredQuestionsProvider = StateNotifierProvider<AnsweredQuestions , List<int>>((ref) => AnsweredQuestions());

class AnsweredQuestions extends StateNotifier<List<int>> {
  AnsweredQuestions() : super([]);

  addQuestion ({required int questionId}){
    state = [...state, questionId];
  }

  removeQuestion ({required int questionId}){
    state = state.where((id) => id != questionId).toList();
  }
}