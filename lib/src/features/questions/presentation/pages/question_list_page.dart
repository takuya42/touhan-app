import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/question_providers.dart';
import 'question_quiz_page.dart';

class QuestionListPage extends ConsumerWidget {
  const QuestionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final wrongQuestionIds = ref.watch(wrongQuestionIdsProvider);

    final filteredQuestions = selectedCategory == null
        ? questions
        : questions
            .where((question) => question.category == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('問題一覧')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('すべて'),
                  selected: selectedCategory == null,
                  onSelected: (_) {
                    ref.read(selectedCategoryProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 8),
                ...QuestionCategory.values.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category.label),
                      selected: selectedCategory == category,
                      onSelected: (_) {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredQuestions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final question = filteredQuestions[index];
                final wrongSaved = wrongQuestionIds.contains(question.id);

                return Card(
                  child: ListTile(
                    title: Text('Q${index + 1}. ${question.questionText}'),
                    subtitle: Text('カテゴリ: ${question.category.label}'),
                    trailing: wrongSaved
                        ? const Icon(Icons.bookmark, color: Colors.orange)
                        : const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => QuestionQuizPage(
                            question: question,
                            questionNumber: index + 1,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
