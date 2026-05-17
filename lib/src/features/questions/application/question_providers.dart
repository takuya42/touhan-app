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

final correctAnswerCountProvider = StateProvider<int>((ref) => 0);
final wrongAnswerCountProvider = StateProvider<int>((ref) => 0);
final studyHistoryProvider = StateProvider<List<String>>((ref) => <String>[]);
final darkModeProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');
final isShuffleModeProvider = StateProvider<bool>((ref) => false);
final isRandomModeProvider = StateProvider<bool>((ref) => false);
final favoriteQuestionIdsProvider =
    StateNotifierProvider<FavoriteQuestionIdsNotifier, Set<String>>(
      (ref) => FavoriteQuestionIdsNotifier(),
    );
final currentStreakProvider = StateProvider<int>((ref) => 0);
final todayStudySecondsProvider = StateProvider<int>((ref) => 0);

class FavoriteQuestionIdsNotifier extends StateNotifier<Set<String>> {
  FavoriteQuestionIdsNotifier() : super(<String>{});

  void toggle(String questionId) {
    if (state.contains(questionId)) {
      state = {...state}..remove(questionId);
      return;
    }
    state = {...state, questionId};
  }

  void setAll(List<String> ids) {
    state = ids.toSet();
  }
}

extension WrongQuestionIdsPersistence on WrongQuestionIdsNotifier {
  void setAll(List<String> ids) {
    state = ids.toSet();
  }
}
