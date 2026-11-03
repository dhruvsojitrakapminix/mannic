import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'app_config.dart';

/// Checks the installed version vs. Remote Config minimum version.
class AppUpdateService {
  AppUpdateService._();
  static final AppUpdateService instance = AppUpdateService._();

  static const _lastCheckKey = 'app_update_last_check';
  final _box = GetStorage();

  bool _checked = false;

  Future<void> checkOnce() async {
    if (_checked) return;
    _checked = true;

    // Throttle: check at most once per 6 hours
    final last = _box.read<String>(_lastCheckKey);
    if (last != null) {
      final t = DateTime.tryParse(last);
      if (t != null && DateTime.now().difference(t).inHours < 6) return;
    }

    // Read nested update config
    final updateCfg = AppConfigStore.instance.appConfig.appUpdateConfig;

    // If update checks are disabled remotely, do nothing
    if (!updateCfg.enabled) return;

    final info = await PackageInfo.fromPlatform();
    final currentBuild = int.tryParse(info.buildNumber) ?? 0;

    _box.write(_lastCheckKey, DateTime.now().toIso8601String());

    // Compare build numbers (simplest, most reliable)
    final minBuild = updateCfg.minBuildNumber;

    if (minBuild > 0 && currentBuild < minBuild) {
      _showUpdateDialog(
        force: updateCfg.forceUpdate,
        message: updateCfg.updateMessage,
      );
    }
  }

  void _showUpdateDialog({
    required bool force,
    required String message,
  }) {
    final cfg = AppConfigStore.instance.appConfig.appUpdateConfig;
    final storeUrl = Uri.parse(
      Platform.isAndroid ? cfg.androidStoreUrl : cfg.appStoreUrl,
    );

    Get.dialog(
      PopScope(
        canPop: !force,
        child: AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(cfg.updateTitle, style: T.h3),
          content: Text(
            message.isEmpty
                ? 'A newer version of Super Tv is available. Please update to continue.'
                : message,
            style: T.body,
          ),
          actions: [
            if (!force)
              TextButton(
                onPressed: () => Get.back(),
                child: Text(cfg.laterText, style: T.body),
              ),
            ElevatedButton(
              onPressed: () async {
                if (cfg.androidStoreUrl.isEmpty && cfg.appStoreUrl.isEmpty) {
                  Get.back();
                  return;
                }
                if (await canLaunchUrl(storeUrl)) {
                  await launchUrl(
                    storeUrl,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(cfg.buttonText),
            ),
          ],
        ),
      ),
      barrierDismissible: !force,
    );
  }
}