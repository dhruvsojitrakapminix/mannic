import 'package:flutter/foundation.dart';

/// Detects the install source (Play Store, App Store, direct, etc.).
/// Currently a stub that returns safe defaults.
class InstallSourceService {
  InstallSourceService._();
  static final InstallSourceService instance = InstallSourceService._();

  InstallSourceInfo? _info;

  InstallSourceInfo? get info => _info;

  Future<void> init() async {
    // Native plugin (e.g. install_referrer) can populate this.
    // For now, use safe defaults so onboarding gates work.
    _info = const InstallSourceInfo(
      isMarketing: false,
      source: 'unknown',
    );
    debugPrint('InstallSource: $_info');
  }
}

class InstallSourceInfo {
  final bool isMarketing;
  final String source;

  const InstallSourceInfo({
    required this.isMarketing,
    required this.source,
  });

  @override
  String toString() => 'InstallSourceInfo(marketing=$isMarketing, src=$source)';
}