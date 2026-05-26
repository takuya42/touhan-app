import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_providers.dart';
import '../../application/ai_usage_service.dart';

class AiAssistantPage extends ConsumerStatefulWidget {
  const AiAssistantPage({super.key});

  @override
  ConsumerState<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends ConsumerState<AiAssistantPage> {
  final _controller = TextEditingController();
  final _messages = <String>['こんにちは。学習の質問を送信してください。'];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_controller.text.trim().isEmpty || _loading) return;
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return;
    setState(() => _loading = true);

    final usage = AiUsageService();
    final canUse = await usage.canUseAi(userId: user.uid);
    if (!canUse && mounted) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('利用上限'),
          content: const Text('本日の無料利用回数を超えました。\nProプランでAI機能を無制限利用できます。'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
      setState(() => _loading = false);
      return;
    }

    await usage.consumeAiUse(userId: user.uid);
    final text = _controller.text.trim();
    _controller.clear();
    setState(() {
      _messages.add('あなた: $text');
      _messages.add('AI: 要点を3つに分けて暗記すると効率的です。');
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI学習アシスタント')),
      body: Column(children: [
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _messages.length, itemBuilder: (_, i) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Text(_messages[i]))))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(children: [Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: '質問を入力'))), const SizedBox(width: 8), FilledButton(onPressed: _loading ? null : _send, child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded))]),
        )
      ]),
    );
  }
}
