import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ai_explanation_service.dart';
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
  ConsumerState<QuestionQuizPage> createState() => _QuestionQuizPageState();
}

class _QuestionQuizPageState extends ConsumerState<QuestionQuizPage> {
  int? _selectedIndex;
  bool _submitted = false;
  String? _aiExplanation;
  bool _aiLoading = false;

  void _submitAnswer() {
    if (_selectedIndex == null) return;
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
      ref.read(wrongQuestionIdsProvider.notifier).add(widget.question.id);
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
    final isCorrect = _selectedIndex != null &&
        widget.question.isCorrect(_selectedIndex!);

    return Scaffold(
      appBar: AppBar(title: Text('問題 ${widget.questionNumber}')),
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
                      correctIndex: widget.question.correctIndex,
                      submitted: _submitted,
                      onTap: () {
                        if (_submitted) return;
                        setState(() => _selectedIndex = index);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              if (_submitted)
                _ResultCard(
                  correct: isCorrect,
                  explanation: widget.question.explanation,
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitted ? null : _submitAnswer,
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
                          .read(wrongQuestionIdsProvider.notifier)
                          .add(widget.question.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('間違えた問題に保存しました')),
                      );
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('間違えた問題として保存'),
                  ),
                ),
              ],
              if (_submitted) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _aiLoading
                        ? null
                        : () async {
                            setState(() => _aiLoading = true);
                            final service = MockAiExplanationService();
                            final value = await service.generateExplanation(widget.question);
                            if (!mounted) return;
                            setState(() {
                              _aiExplanation = value;
                              _aiLoading = false;
                            });
                          },
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(_aiLoading ? 'AI解説を生成中...' : 'AI解説を見る'),
                  ),
                ),
              ],
              if (_aiExplanation != null) ...[
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(_aiExplanation!),
                  ),
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
  const _ResultCard({required this.correct, required this.explanation});

  final bool correct;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final color = correct ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(correct ? Icons.check_circle : Icons.cancel, color: color),
                const SizedBox(width: 8),
                Text(
                  correct ? '正解です！' : '不正解です',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.bold),
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
