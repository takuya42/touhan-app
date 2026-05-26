import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'プライバシーポリシー',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Text(
            '登録販売者試験対策アプリ（以下、「本アプリ」）は、'
                'ユーザーのプライバシーを尊重し、個人情報の保護に努めます。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '1. 取得する情報',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリでは、以下の情報を取得する場合があります。\n\n'
                '・メールアドレス\n'
                '・学習履歴\n'
                '・利用状況データ\n'
                '・Firebase Authenticationによる認証情報',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '2. 利用目的',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '取得した情報は、以下の目的で利用します。\n\n'
                '・ログイン機能の提供\n'
                '・学習履歴の保存\n'
                '・アプリ機能改善\n'
                '・不具合調査および品質向上\n'
                '・お問い合わせ対応',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '3. 第三者提供',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリは、法令に基づく場合を除き、'
                'ユーザー情報を第三者へ提供しません。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '4. 外部サービス',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリでは、以下の外部サービスを利用する場合があります。\n\n'
                '・Firebase Authentication\n'
                '・Cloud Firestore\n'
                '・Firebase Analytics\n'
                '・Firebase Crashlytics\n\n'
                'これらのサービスでは、利用状況データが自動収集される場合があります。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '5. データ管理',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリは、ユーザー情報の漏洩・紛失・改ざん防止に努めます。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '6. 免責事項',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリ利用によって生じた損害について、'
                '運営者は責任を負いません。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '7. ポリシー変更',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本ポリシーは、必要に応じて変更される場合があります。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '制定日：2026年5月27日',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }
}