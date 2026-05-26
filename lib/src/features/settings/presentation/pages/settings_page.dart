import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('ダークモード'),
            value: ref.watch(darkModeProvider),
            onChanged: (v) => ref.read(darkModeProvider.notifier).state = v,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => ref.read(firebaseAuthProvider).signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('ログアウト'),
          )
        ],
      ),
    );
  }
}
