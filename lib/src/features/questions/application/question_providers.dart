import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/question_seed_data.dart';
import '../domain/question.dart';

final questionsProvider = Provider<List<Question>>((ref) => questionSeedData);

final selectedCategoryProvider = StateProvider<QuestionCategory?>((ref) => null);

class WrongQuestionIdsNotifier extends StateNotifier<Set<String>> {
  WrongQuestionIdsNotifier() : super(<String>{});

  void add(String questionId) {
    state = {...state, questionId};
  }

  void remove(String questionId) {
    final copied = {...state};
    copied.remove(questionId);
    state = copied;
  }
}

final wrongQuestionIdsProvider =
    StateNotifierProvider<WrongQuestionIdsNotifier, Set<String>>(
      (ref) => WrongQuestionIdsNotifier(),
    );
