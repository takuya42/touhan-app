import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/question_providers.dart';
import '../../application/study_persistence.dart';
import '../../domain/question.dart';
import 'question_quiz_page.dart';

class QuestionListPage extends ConsumerWidget {
  const QuestionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final wrongQuestionIds = ref.watch(wrongQuestionIdsProvider);
    final favoriteIds = ref.watch(favoriteQuestionIdsProvider);
    final searchQuery = ref.watch(searchQueryProvider).trim();
    final shuffle = ref.watch(isShuffleModeProvider);
    final random = ref.watch(isRandomModeProvider);

    var filteredQuestions = selectedCategory == null
        ? questions
        : questions
            .where((question) => question.category == selectedCategory)
            .toList();
    if (searchQuery.isNotEmpty) {
      filteredQuestions = filteredQuestions
          .where(
            (q) => q.questionText.contains(searchQuery) || q.choices.any((c) => c.contains(searchQuery)),
          )
          .toList();
    }
    if (shuffle) {
      filteredQuestions = [...filteredQuestions]..shuffle();
    }
    if (random && filteredQuestions.isNotEmpty) {
      filteredQuestions = [([...filteredQuestions]..shuffle()).first];
    }

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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
              decoration: const InputDecoration(
                hintText: '問題を検索',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('シャッフル'),
                  selected: shuffle,
                  onSelected: (v) => ref.read(isShuffleModeProvider.notifier).state = v,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('ランダム1問'),
                  selected: random,
                  onSelected: (v) => ref.read(isRandomModeProvider.notifier).state = v,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            ref.read(favoriteQuestionIdsProvider.notifier).toggle(question.id);
                            await ref.read(studyPersistenceProvider).save(ref);
                          },
                          icon: Icon(
                            favoriteIds.contains(question.id) ? Icons.favorite : Icons.favorite_border,
                            color: favoriteIds.contains(question.id) ? Colors.pink : null,
                          ),
                        ),
                        wrongSaved
                            ? const Icon(Icons.bookmark, color: Colors.orange)
                            : const Icon(Icons.chevron_right),
                      ],
                    ),
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
