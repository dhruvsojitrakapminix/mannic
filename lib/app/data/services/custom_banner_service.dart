import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Simple in-app banner (promo) fetched from Remote Config / storage.
class CustomBannerService {
  CustomBannerService._();
  static final CustomBannerService instance = CustomBannerService._();

  static const _cacheKey = 'custom_banner_cache_v1';
  final _box = GetStorage();

  final bannerMessage = ''.obs;
  final bannerCtaUrl = ''.obs;
  final bannerEnabled = false.obs;

  void init() {
    final cached = _box.read(_cacheKey);
    if (cached is Map) {
      bannerMessage.value = cached['message'] as String? ?? '';
      bannerCtaUrl.value = cached['url'] as String? ?? '';
      bannerEnabled.value = cached['enabled'] as bool? ?? false;
    }
  }

  Future<void> refresh() async {
    // Hook for Remote Config / API. For now, no-op.
  }

  void show(String message, {String url = ''}) {
    bannerMessage.value = message;
    bannerCtaUrl.value = url;
    bannerEnabled.value = true;
    _box.write(_cacheKey, {
      'message': message,
      'url': url,
      'enabled': true,
    });
  }

  void dismiss() {
    bannerEnabled.value = false;
    _box.write(_cacheKey, {
      'message': bannerMessage.value,
      'url': bannerCtaUrl.value,
      'enabled': false,
    });
  }
}