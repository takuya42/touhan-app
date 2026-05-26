import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/application/auth_providers.dart';
import '../../../purchase/presentation/pages/pro_plan_page.dart';
import '../../../questions/application/question_providers.dart';
import '../../../questions/application/study_persistence.dart';
import 'account_info_page.dart';
import 'admin_pro_users_page.dart';
import 'privacy_policy_page.dart';
import 'terms_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(context, 'アカウント', [
            _item(context, 'アカウント情報', CupertinoIcons.person_crop_circle, onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const AccountInfoPage()));
            }),
            _item(context, 'ログアウト', CupertinoIcons.square_arrow_right, onTap: () {
              ref.read(firebaseAuthProvider).signOut();
            }),
          ]),
          _sectionCard(context, 'プラン', [
            _item(context, 'Proプラン', CupertinoIcons.star_circle, onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ProPlanPage()));
            }),
          ]),
          _sectionCard(context, 'サポート', [
            _item(context, '利用規約', CupertinoIcons.doc_text, onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const TermsPage()));
            }),
            _item(context, 'プライバシーポリシー', CupertinoIcons.lock_shield, onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyPage()));
            }),
            _item(context, 'お問い合わせ', CupertinoIcons.mail, onTap: () async {
              final uri = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSe_ku1s4EP-7nWw_wZDb27gJeRdppEh4Hb20cwF1cj1aIlCOg/viewform?usp=dialog');
              await launchUrl(uri);
            }),
          ]),
          _sectionCard(context, '管理', [
            _item(context, 'Proユーザー管理', CupertinoIcons.person_2_square_stack, onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const AdminProUsersPage()));
            }),
          ]),
          _sectionCard(context, 'その他', [
            _item(context, 'データ初期化', CupertinoIcons.trash, onTap: () async {
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
          ]),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
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
      trailing: const Icon(CupertinoIcons.chevron_forward, size: 18),
      onTap: onTap,
    );
  }
}
