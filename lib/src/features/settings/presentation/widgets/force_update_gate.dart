import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// ===============================
/// Force Update State
/// ===============================

class ForceUpdateState {
  const ForceUpdateState({
    required this.required,
    required this.currentVersion,
    required this.minimumVersion,
  });

  final bool required;
  final String currentVersion;
  final String minimumVersion;
}

/// ===============================
/// Remote Config Provider
/// ===============================

final remoteConfigProvider =
Provider<FirebaseRemoteConfig>((ref) {
  return FirebaseRemoteConfig.instance;
});

/// ===============================
/// Force Update Provider
/// ===============================

final forceUpdateProvider =
FutureProvider<ForceUpdateState>((ref) async {
  final remoteConfig = ref.read(remoteConfigProvider);

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),

      /// 開発中はキャッシュなし
      minimumFetchInterval: Duration.zero,
    ),
  );

  /// デフォルト値
  await remoteConfig.setDefaults({
    'minimum_version_ios': '1.0.0',
  });

  await remoteConfig.fetchAndActivate();

  final packageInfo = await PackageInfo.fromPlatform();

  final currentVersion = packageInfo.version;

  final minimumVersion =
  remoteConfig.getString('minimum_version_ios');

  debugPrint('====================');
  debugPrint('currentVersion: $currentVersion');
  debugPrint('minimumVersion: $minimumVersion');
  debugPrint('====================');

  final required = _isVersionLower(
    currentVersion,
    minimumVersion,
  );

  return ForceUpdateState(
    required: required,
    currentVersion: currentVersion,
    minimumVersion: minimumVersion,
  );
});

/// ===============================
/// Version Compare
/// ===============================

bool _isVersionLower(
    String currentVersion,
    String minimumVersion,
    ) {
  final current =
  currentVersion.split('.').map(int.parse).toList();

  final minimum =
  minimumVersion.split('.').map(int.parse).toList();

  final maxLength =
  current.length > minimum.length
      ? current.length
      : minimum.length;

  for (int i = 0; i < maxLength; i++) {
    final currentPart =
    i < current.length ? current[i] : 0;

    final minimumPart =
    i < minimum.length ? minimum[i] : 0;

    if (currentPart < minimumPart) {
      return true;
    }

    if (currentPart > minimumPart) {
      return false;
    }
  }

  return false;
}

/// ===============================
/// Force Update Gate
/// ===============================

class ForceUpdateGate extends ConsumerStatefulWidget {
  const ForceUpdateGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ForceUpdateGate> createState() =>
      _ForceUpdateGateState();
}

class _ForceUpdateGateState
    extends ConsumerState<ForceUpdateGate> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(forceUpdateProvider, (_, next) {
        next.whenData((state) {
          if (!_dialogShown && state.required) {
            _dialogShown = true;
            _showForceUpdateDialog();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            content: const Text(
              '最新バージョンのアプリへアップデートしてください。',
            ),
            actions: [
              FilledButton(
                onPressed: _openStore,
                child: const Text('アップデートする'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openStore() async {
    if (!Platform.isIOS) return;

    /// App Store URL
    const url =
        'https://apps.apple.com/jp/app/idXXXXXXXXXX';

    final uri = Uri.parse(url);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}