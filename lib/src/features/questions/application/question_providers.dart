import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../auth/application/auth_providers.dart';

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
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

class FreeAnswerLimitResult {
  const FreeAnswerLimitResult({required this.canAnswer});

  final bool canAnswer;
}

class FreeAnswerLimitService {
  FreeAnswerLimitService(this.ref);

  final Ref ref;

  Future<FreeAnswerLimitResult> consumeAnswerAttempt() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) {
      return const FreeAnswerLimitResult(canAnswer: false);
    }

    final users = ref.read(firestoreProvider).collection('users');
    final docRef = users.doc(user.uid);

    final result = await ref.read(firestoreProvider).runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.data() ?? <String, dynamic>{};

      final plan = data['plan'] as String? ?? 'free';
      if (plan == 'pro') {
        return const FreeAnswerLimitResult(canAnswer: true);
      }

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final savedDate = data['freeAnswerDate'] as String?;
      var count = (data['freeAnswerCount'] as num?)?.toInt() ?? 0;

      if (savedDate != today) {
        count = 0;
      }

      if (count >= 3) {
        tx.set(docRef, {
          'freeAnswerCount': count,
          'freeAnswerDate': today,
        }, SetOptions(merge: true));
        return const FreeAnswerLimitResult(canAnswer: false);
      }

      tx.set(docRef, {
        'freeAnswerCount': count + 1,
        'freeAnswerDate': today,
      }, SetOptions(merge: true));

      return const FreeAnswerLimitResult(canAnswer: true);
    });

    return result;
  }
}

final freeAnswerLimitServiceProvider = Provider<FreeAnswerLimitService>(
  (ref) => FreeAnswerLimitService(ref),
);

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
