import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/study_persistence.dart';
import '../../application/question_providers.dart';
import '../../domain/question.dart';
import 'question_list_page.dart';
import 'question_quiz_page.dart';

class HomeShellPage extends ConsumerStatefulWidget {
  const HomeShellPage({super.key});

  @override
  ConsumerState<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends ConsumerState<HomeShellPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(studyPersistenceProvider).load(ref);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeDashboard(onStart: () => setState(() => _currentIndex = 1)),
      const QuestionListPage(),
      const _WrongQuestionsPage(),
      const _StudyHistoryPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: '問題'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), selectedIcon: Icon(Icons.bookmark), label: '復習'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: '履歴'),
        ],
      ),
    );
  }
}

class _HomeDashboard extends ConsumerWidget {
  const _HomeDashboard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correct = ref.watch(correctAnswerCountProvider);
    final wrong = ref.watch(wrongAnswerCountProvider);
    final darkMode = ref.watch(darkModeProvider);
    final streak = ref.watch(currentStreakProvider);
    final todayStudySec = ref.watch(todayStudySecondsProvider);
    final total = (correct + wrong);
    final accuracy = total == 0 ? 0.0 : correct / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('登録販売者 試験対策'),
        actions: [
          Switch(
            value: darkMode,
            onChanged: (value) async {
              ref.read(darkModeProvider.notifier).state = value;
              await ref.read(studyPersistenceProvider).save(ref);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('学習状況', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _StatTile(label: '正解数', value: '$correct', color: Colors.teal)),
                      const SizedBox(width: 12),
                      Expanded(child: _StatTile(label: '不正解数', value: '$wrong', color: Colors.deepOrange)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: accuracy),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) => LinearProgressIndicator(value: value),
                  ),
                  const SizedBox(height: 6),
                  Text('正答率: ${(accuracy * 100).toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ランキング風 学習表示', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(child: Text('🥇')),
                    title: const Text('あなた'),
                    subtitle: Text('連続正解: $streak'),
                    trailing: Text('学習 ${(todayStudySec / 60).toStringAsFixed(1)}分'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('カテゴリ別学習', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...QuestionCategory.values.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(category.label),
                  subtitle: const Text('基礎問題を学習する'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onStart,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: const Text('問題を解く'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _WrongQuestionsPage extends ConsumerWidget {
  const _WrongQuestionsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final wrongIds = ref.watch(wrongQuestionIdsProvider);
    final wrongQuestions = questions.where((q) => wrongIds.contains(q.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('間違えた問題')),
      body: wrongQuestions.isEmpty
          ? const Center(child: Text('まだ間違えた問題はありません'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: wrongQuestions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final question = wrongQuestions[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Text(question.questionText),
                    subtitle: Text('カテゴリ: ${question.category.label}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => QuestionQuizPage(question: question, questionNumber: index + 1),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _StudyHistoryPage extends ConsumerWidget {
  const _StudyHistoryPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(studyHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('学習履歴')),
      body: history.isEmpty
          ? const Center(child: Text('履歴はまだありません'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final parts = history[index].split('|');
                final dateLabel = parts.isNotEmpty ? parts[0] : '-';
                final questionId = parts.length > 1 ? parts[1] : '-';
                final result = parts.length > 2 ? parts[2] : '-';

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Icon(result == 'correct' ? Icons.check_circle : Icons.cancel),
                    title: Text('問題ID: $questionId'),
                    subtitle: Text(dateLabel),
                    trailing: Text(result == 'correct' ? '正解' : '不正解'),
                  ),
                );
              },
            ),
    );
  }
}
