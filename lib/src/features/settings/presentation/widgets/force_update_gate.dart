import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/force_update_providers.dart';

class ForceUpdateGate extends ConsumerStatefulWidget {
  const ForceUpdateGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ForceUpdateGate> createState() => _ForceUpdateGateState();
}

class _ForceUpdateGateState extends ConsumerState<ForceUpdateGate> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(forceUpdateProvider, (_, next) {
      next.whenData((state) {
        if (!_dialogShown && state.required) {
          _dialogShown = true;
          _showForceUpdateDialog();
        }
      });
    });

    return widget.child;
  }

  Future<void> _showForceUpdateDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('アップデートが必要です'),
            content: const Text('アプリを最新バージョンに更新してください。'),
            actions: [
              FilledButton(
                onPressed: _openAppStore,
                child: const Text('アップデートする'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAppStore() async {
    if (!Platform.isIOS) return;

    // TODO: 実際のApp Store URLに置き換えてください。
    final uri = Uri.parse('https://apps.apple.com/app/id0000000000');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
