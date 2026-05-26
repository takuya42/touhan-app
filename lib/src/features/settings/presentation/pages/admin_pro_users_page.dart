import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProUsersPage extends StatelessWidget {
  const AdminProUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(title: const Text('Proユーザー管理')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: usersRef.snapshots(),
        builder: (context, allUsersSnapshot) {
          if (allUsersSnapshot.hasError) {
            return Center(child: Text('ユーザー取得エラー: ${allUsersSnapshot.error}'));
          }
          if (!allUsersSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allUsersCount = allUsersSnapshot.data!.docs.length;

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: usersRef.where('plan', isEqualTo: 'pro').snapshots(),
            builder: (context, proUsersSnapshot) {
              if (proUsersSnapshot.hasError) {
                return Center(child: Text('Proユーザー取得エラー: ${proUsersSnapshot.error}'));
              }
              if (!proUsersSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final proDocs = proUsersSnapshot.data!.docs;
              final proCount = proDocs.length;
              final freeCount = (allUsersCount - proCount).clamp(0, allUsersCount);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pro Users ($proCount)', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text('free users: $freeCount', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (proDocs.isEmpty)
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Proユーザーはいません'),
                      ),
                    )
                  else
                    ...proDocs.map((doc) {
                      final data = doc.data();
                      final email = data['email'] as String? ?? '-';
                      final uid = doc.id;
                      final plan = data['plan'] as String? ?? '-';

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(email, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text('uid: $uid'),
                              Text('plan: $plan'),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
