import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/question_providers.dart';
import '../../application/study_persistence.dart';
import '../../domain/question.dart';
import '../widgets/choice_tile.dart';

class QuestionQuizPage extends ConsumerStatefulWidget {
  const QuestionQuizPage({
    super.key,
    required this.question,
    required this.questionNumber,
  });

  final Question question;
  final int questionNumber;

  @override
  ConsumerState<QuestionQuizPage> createState() =>
      _QuestionQuizPageState();
}

class _QuestionQuizPageState
    extends ConsumerState<QuestionQuizPage> {
  int? _selectedIndex;
  bool _submitted = false;

  Future<void> _submitAnswer() async {
    if (_selectedIndex == null) return;

    final limitResult = await ref
        .read(freeAnswerLimitServiceProvider)
        .consumeAnswerAttempt();

    if (!limitResult.canAnswer) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('利用上限に達しました'),
            content: const Text('Proプランで無制限に利用できます'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          );
        },
      );
      return;
    }

    final selected = _selectedIndex!;
    final isCorrect = widget.question.isCorrect(selected);

    setState(() {
      _submitted = true;
    });

    if (isCorrect) {
      ref.read(correctAnswerCountProvider.notifier).state++;
      ref.read(currentStreakProvider.notifier).state++;
    } else {
      ref.read(wrongAnswerCountProvider.notifier).state++;
      ref
          .read(wrongQuestionIdsProvider.notifier)
          .add(widget.question.id);

      ref.read(currentStreakProvider.notifier).state = 0;
    }

    ref.read(todayStudySecondsProvider.notifier).state += 30;

    final historyEntry =
        '${DateTime.now().toIso8601String()}|${widget.question.id}|${isCorrect ? 'correct' : 'wrong'}';

    ref.read(studyHistoryProvider.notifier).state = [
      historyEntry,
      ...ref.read(studyHistoryProvider),
    ];

    ref.read(studyPersistenceProvider).save(ref);
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(questionsProvider);

    final isCorrect = _selectedIndex != null &&
        widget.question.isCorrect(_selectedIndex!);

    return Scaffold(
      appBar: AppBar(
        title: Text('問題 ${widget.questionNumber}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.question.category.label,
                style: Theme.of(context).textTheme.labelLarge,
              ),

              const SizedBox(height: 8),

              Text(
                widget.question.questionText,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: widget.question.choices.length,
                  itemBuilder: (context, index) {
                    return ChoiceTile(
                      text: widget.question.choices[index],
                      index: index,
                      selectedIndex: _selectedIndex,
                      correctIndex:
                      widget.question.correctIndex,
                      submitted: _submitted,
                      onTap: () {
                        if (_submitted) return;

                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              if (_submitted)
                _ResultCard(
                  correct: isCorrect,
                  explanation:
                  widget.question.explanation,
                ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitted
                      ? null
                      : () async {
                          await _submitAnswer();
                        },
                  child: const Text('回答する'),
                ),
              ),

              if (_submitted && !isCorrect) ...[
                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref
                          .read(
                        wrongQuestionIdsProvider
                            .notifier,
                      )
                          .add(widget.question.id);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content:
                          Text('間違えた問題に保存しました'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.bookmark_add_outlined,
                    ),
                    label:
                    const Text('間違えた問題として保存'),
                  ),
                ),
              ],

              if (_submitted) ...[
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final currentIndex =
                          questions.indexWhere(
                                (q) =>
                            q.id ==
                                widget.question.id,
                          );

                          final nextIndex =
                          currentIndex >= 0
                              ? (currentIndex + 1) %
                              questions.length
                              : 0;

                          final nextQuestion =
                          questions[nextIndex];

                          Navigator.of(context)
                              .pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  QuestionQuizPage(
                                    question:
                                    nextQuestion,
                                    questionNumber:
                                    nextIndex + 1,
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                        ),
                        label: const Text('次へ'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          final otherQuestions =
                          questions
                              .where(
                                (q) =>
                            q.id !=
                                widget
                                    .question
                                    .id,
                          )
                              .toList();

                          otherQuestions.shuffle();

                          final randomQuestion =
                          otherQuestions.isEmpty
                              ? widget.question
                              : otherQuestions
                              .first;

                          final randomIndex =
                          questions.indexWhere(
                                (q) =>
                            q.id ==
                                randomQuestion.id,
                          );

                          Navigator.of(context)
                              .pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  QuestionQuizPage(
                                    question:
                                    randomQuestion,
                                    questionNumber:
                                    randomIndex + 1,
                                  ),
                            ),
                          );
                        },
                        icon:
                        const Icon(Icons.shuffle),
                        label:
                        const Text('ランダム'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.correct,
    required this.explanation,
  });

  final bool correct;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final color =
    correct ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  correct
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: color,
                ),

                const SizedBox(width: 8),

                Text(
                  correct
                      ? '正解です！'
                      : '不正解です',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    color: color,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text('解説: $explanation'),
          ],
        ),
      ),
    );
  }
}
