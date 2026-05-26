import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_providers.dart';
import '../../../purchase/presentation/pages/pro_plan_page.dart';
import '../../../questions/application/question_providers.dart';
import '../../../questions/application/study_persistence.dart';
import '../../../questions/domain/question.dart';
import '../../../questions/presentation/pages/question_list_page.dart';
import '../../../questions/presentation/pages/question_quiz_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

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
    Future<void>.microtask(() => ref.read(studyPersistenceProvider).load(ref));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeDashboard(onStart: () => setState(() => _currentIndex = 1)),
      const QuestionListPage(),
      const _WrongQuestionsPage(),
      const _StudyHistoryPage(),
      const ProPlanPage(),
      const SettingsPage(),
    ];
    _currentIndex = _currentIndex.clamp(0, pages.length - 1);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), label: 'ホーム'),
              NavigationDestination(icon: Icon(Icons.quiz_outlined), label: '問題'),
              NavigationDestination(icon: Icon(Icons.bookmark_border), label: '復習'),
              NavigationDestination(icon: Icon(Icons.timeline_outlined), label: '履歴'),
              NavigationDestination(icon: Icon(Icons.workspace_premium_outlined), label: 'Pro'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), label: '設定'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeDashboard extends ConsumerWidget { const _HomeDashboard({required this.onStart}); final VoidCallback onStart;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correct = ref.watch(correctAnswerCountProvider);
    final wrong = ref.watch(wrongAnswerCountProvider);
    final streak = ref.watch(currentStreakProvider);
    return ListView(padding: const EdgeInsets.all(20), children: [
      Card(elevation: 3, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('学習状況', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 16),
        Row(children:[Expanded(child: _stat('正解', '$correct')), const SizedBox(width: 12), Expanded(child: _stat('不正解', '$wrong'))]),
      ]))),
      const SizedBox(height: 14),
      Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.emoji_events_outlined)), title: const Text('ランキング風 学習表示'), subtitle: Text('現在の連続正解: $streak 問'))),
      const SizedBox(height: 12),
      ...QuestionCategory.values.map((c) => Card(child: ListTile(leading: const Icon(Icons.book_outlined), title: Text(c.label), trailing: const Icon(Icons.chevron_right), onTap: onStart))),
      const SizedBox(height: 16), FilledButton.icon(onPressed: onStart, icon: const Icon(Icons.play_arrow_rounded), label: const Text('問題を解く'))
    ]);
  }
  Widget _stat(String l, String v)=>Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFEAFBF6),borderRadius:BorderRadius.circular(18)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(l),Text(v,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w700))]));
}

class _WrongQuestionsPage extends ConsumerWidget { const _WrongQuestionsPage(); @override Widget build(BuildContext context, WidgetRef ref) => const Scaffold(body: Center(child: Text('復習は問題タブから利用できます'))); }
class _StudyHistoryPage extends ConsumerWidget { const _StudyHistoryPage(); @override Widget build(BuildContext context, WidgetRef ref) => const Scaffold(body: Center(child: Text('履歴表示'))); }
