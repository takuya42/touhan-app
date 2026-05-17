import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/question_providers.dart';
import '../../application/study_persistence.dart';
import 'ai_chat_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    final notifications = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('学習者プロフィール'),
              subtitle: const Text('登録販売者 試験対策を継続中'),
              trailing: const Icon(Icons.emoji_events_outlined),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: darkMode,
            title: const Text('ダークモード'),
            onChanged: (value) async {
              ref.read(darkModeProvider.notifier).state = value;
              await ref.read(studyPersistenceProvider).save(ref);
            },
          ),
          SwitchListTile(
            value: notifications,
            title: const Text('通知 ON/OFF'),
            onChanged: (value) async {
              ref.read(notificationsEnabledProvider.notifier).state = value;
              await ref.read(studyPersistenceProvider).save(ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('利用規約'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const _SimpleDocPage(title: '利用規約'))),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const _SimpleDocPage(title: 'プライバシーポリシー'))),
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('お問い合わせ'),
            subtitle: const Text('support@example.com'),
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: const Text('AIチャット学習'),
            subtitle: const Text('ChatGPT風UIで質問練習'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AiChatPage())),
          ),
          const Divider(),
          FilledButton.tonalIcon(
            onPressed: () async {
              ref.read(correctAnswerCountProvider.notifier).state = 0;
              ref.read(wrongAnswerCountProvider.notifier).state = 0;
              ref.read(studyHistoryProvider.notifier).state = <String>[];
              ref.read(wrongQuestionIdsProvider.notifier).setAll(<String>[]);
              ref.read(favoriteQuestionIdsProvider.notifier).setAll(<String>[]);
              ref.read(currentStreakProvider.notifier).state = 0;
              ref.read(todayStudySecondsProvider.notifier).state = 0;
              await ref.read(studyPersistenceProvider).save(ref);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('学習データをリセット'),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('App Version 1.0.0+1', style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _SimpleDocPage extends StatelessWidget {
  const _SimpleDocPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('$title（サンプル）\n\n本アプリは学習用途のための教材アプリです。'),
      ),
    );
  }
}
