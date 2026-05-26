import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateState {
  const ForceUpdateState({
    required this.required,
    required this.minVersion,
    required this.currentVersion,
  });

  final bool required;
  final String minVersion;
  final String currentVersion;
}

final forceUpdateProvider = FutureProvider<ForceUpdateState>((ref) async {
  if (!Platform.isIOS) {
    return const ForceUpdateState(
      required: false,
      minVersion: '',
      currentVersion: '',
    );
  }

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  await remoteConfig.fetchAndActivate();

  final minVersion = remoteConfig.getString('min_version_ios').trim();
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version.trim();

  final required = _isVersionLower(currentVersion, minVersion);

  return ForceUpdateState(
    required: required,
    minVersion: minVersion,
    currentVersion: currentVersion,
  );
});

bool _isVersionLower(String current, String minimum) {
  if (minimum.isEmpty) return false;

  final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final minimumParts = minimum.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final length = currentParts.length > minimumParts.length
      ? currentParts.length
      : minimumParts.length;

  for (var i = 0; i < length; i++) {
    final currentValue = i < currentParts.length ? currentParts[i] : 0;
    final minimumValue = i < minimumParts.length ? minimumParts[i] : 0;
    if (currentValue < minimumValue) return true;
    if (currentValue > minimumValue) return false;
  }

  return false;
}
