import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            '利用規約',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Text(
            '本利用規約（以下、「本規約」）は、登録販売者試験対策アプリ（以下、「本アプリ」）の利用条件を定めるものです。'
                'ユーザーの皆さまには、本規約に同意の上、本アプリをご利用いただきます。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第1条（適用）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本規約は、ユーザーと本アプリ運営者との間の本アプリ利用に関わる一切の関係に適用されます。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第2条（利用内容）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリは、登録販売者試験対策を目的とした学習支援サービスを提供します。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第3条（禁止事項）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'ユーザーは、以下の行為を行ってはなりません。\n\n'
                '・法令または公序良俗に違反する行為\n'
                '・本アプリの運営を妨害する行為\n'
                '・不正アクセスを試みる行為\n'
                '・本アプリ内コンテンツの無断転載・再配布\n'
                '・その他、運営者が不適切と判断する行為',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第4条（課金機能）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリには買い切り型のProプランがあります。'
                '購入後はAppleまたはGoogleの購入ポリシーに従って管理されます。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第5条（免責事項）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリは学習支援を目的としたものであり、試験合格を保証するものではありません。'
                'また、本アプリ利用によって発生した損害について、運営者は責任を負いません。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第6条（サービス変更）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '運営者は、ユーザーへの事前通知なく、本アプリの内容変更・停止・終了を行うことがあります。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第7条（著作権）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '本アプリ内の文章・画像・デザイン等の著作権は、運営者または正当な権利者に帰属します。',
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),

          SizedBox(height: 24),

          Text(
            '第8条（規約変更）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            '運営者は、必要に応じて本規約を変更できるものとします。',
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