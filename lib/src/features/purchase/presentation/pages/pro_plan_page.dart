import 'package:flutter/material.dart';

class ProPlanPage extends StatelessWidget {
  const ProPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proプラン')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('買い切り 1,580円', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('・AI無制限\n・広告なし\n・今後の追加機能も利用可能'),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: const Text('購入する（準備中）')),
        ],
      ),
    );
  }
}
