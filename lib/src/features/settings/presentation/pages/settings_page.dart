import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_providers.dart';
import '../../../purchase/presentation/pages/pro_plan_page.dart';
import '../../../questions/application/question_providers.dart';
import '../../../questions/application/study_persistence.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionCard(
            context,
            'アカウント',
            [
              _item(context, 'アカウント情報', Icons.person_outline),
              _item(context, 'ログアウト', Icons.logout, onTap: () => ref.read(firebaseAuthProvider).signOut()),
            ],
          ),
          _sectionCard(
            context,
            'プラン',
            [
              _item(context, 'Proプラン', Icons.workspace_premium_outlined, onTap: () {
                Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ProPlanPage()));
              }),
            ],
          ),
          _sectionCard(
            context,
            'サポート',
            [
              _item(context, '利用規約', Icons.description_outlined),
              _item(context, 'プライバシーポリシー', Icons.policy_outlined),
              _item(context, 'お問い合わせ', Icons.email_outlined),
              _item(context, 'レビューを書く', Icons.rate_review_outlined),
              _item(context, 'シェアする', Icons.share_outlined),
            ],
          ),
          _sectionCard(
            context,
            'その他',
            [
              _item(context, 'データ初期化', Icons.delete_sweep_outlined, onTap: () async {
                ref.read(correctAnswerCountProvider.notifier).state = 0;
                ref.read(wrongAnswerCountProvider.notifier).state = 0;
                ref.read(currentStreakProvider.notifier).state = 0;
                ref.read(todayStudySecondsProvider.notifier).state = 0;
                ref.read(studyHistoryProvider.notifier).state = <String>[];
                ref.read(wrongQuestionIdsProvider.notifier).setAll(<String>[]);
                await ref.read(studyPersistenceProvider).save(ref);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('学習データを初期化しました')));
                }
              }),
              const ListTile(title: Text('アプリバージョン'), trailing: Text('1.0.0')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap ?? () {},
    );
  }
}
