import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'question_providers.dart';

class StudyPersistenceService {
  static const _keyDarkMode = 'dark_mode';
  static const _keyCorrectCount = 'correct_count';
  static const _keyWrongCount = 'wrong_count';
  static const _keyWrongIds = 'wrong_ids';
  static const _keyHistory = 'study_history';
  static const _keyFavorites = 'favorite_ids';
  static const _keyStreak = 'current_streak';
  static const _keyStudySec = 'today_study_seconds';

  Future<void> load(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    ref.read(darkModeProvider.notifier).state = prefs.getBool(_keyDarkMode) ?? false;
    ref.read(correctAnswerCountProvider.notifier).state = prefs.getInt(_keyCorrectCount) ?? 0;
    ref.read(wrongAnswerCountProvider.notifier).state = prefs.getInt(_keyWrongCount) ?? 0;
    ref.read(wrongQuestionIdsProvider.notifier).setAll(prefs.getStringList(_keyWrongIds) ?? <String>[]);
    ref.read(studyHistoryProvider.notifier).state = prefs.getStringList(_keyHistory) ?? <String>[];
    ref.read(favoriteQuestionIdsProvider.notifier).setAll(prefs.getStringList(_keyFavorites) ?? <String>[]);
    ref.read(currentStreakProvider.notifier).state = prefs.getInt(_keyStreak) ?? 0;
    ref.read(todayStudySecondsProvider.notifier).state = prefs.getInt(_keyStudySec) ?? 0;
  }

  Future<void> save(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, ref.read(darkModeProvider));
    await prefs.setInt(_keyCorrectCount, ref.read(correctAnswerCountProvider));
    await prefs.setInt(_keyWrongCount, ref.read(wrongAnswerCountProvider));
    await prefs.setStringList(_keyWrongIds, ref.read(wrongQuestionIdsProvider).toList());
    await prefs.setStringList(_keyHistory, ref.read(studyHistoryProvider));
    await prefs.setStringList(_keyFavorites, ref.read(favoriteQuestionIdsProvider).toList());
    await prefs.setInt(_keyStreak, ref.read(currentStreakProvider));
    await prefs.setInt(_keyStudySec, ref.read(todayStudySecondsProvider));
  }
}

final studyPersistenceProvider = Provider<StudyPersistenceService>((ref) {
  return StudyPersistenceService();
});
