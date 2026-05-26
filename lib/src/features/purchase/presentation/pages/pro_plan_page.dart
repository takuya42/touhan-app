import 'package:flutter/material.dart';

class ProPlanPage extends StatelessWidget {
  const ProPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proプラン'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6EE7B7),
                  Color(0xFF34D399),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'おすすめ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Proプラン',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    '買い切り 980円',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),


                  _feature(
                    Icons.quiz_outlined,
                    '問題回答 無制限',
                  ),

                  _feature(
                    Icons.analytics_outlined,
                    '苦手分析',
                  ),
                  _feature(
                    Icons.history,
                    '学習履歴',
                  ),

                  _feature(
                    Icons.update,
                    '今後の追加機能も利用可能',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.workspace_premium_outlined,
              ),
              label: const Text(
                '購入する（準備中）',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              '一度購入すると追加料金なしで利用できます',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.check,
              color: Color(0xFF34D399),
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}