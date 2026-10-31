import 'dart:convert';

import 'package:get_storage/get_storage.dart';

// ─────────────────────────────────────────────
//  Nested models matching your JSON schema
// ─────────────────────────────────────────────

class ApiData {
  final String base;
  final String fbId;
  final String fbToken;
  final bool isMarketing;
  final bool isshowAdTapOnApp;
  final String img;
  final String imgBig;
  final String token; // TMDB bearer token

  ApiData({
    required this.base,
    required this.fbId,
    required this.fbToken,
    required this.isMarketing,
    required this.isshowAdTapOnApp,
    required this.img,
    required this.imgBig,
    required this.token,
  });

  factory ApiData.fromJson(Map<String, dynamic> j) => ApiData(
    base: j['base'] ?? 'https://api.themoviedb.org/3',
    fbId: j['fbId'] ?? '',
    fbToken: j['fbToken'] ?? '',
    isMarketing: j['isMarketing'] ?? false,
    isshowAdTapOnApp: j['isshowAdTapOnApp'] ?? false,
    img: j['img'] ?? 'https://image.tmdb.org/t/p/w500',
    imgBig: j['imgBig'] ?? 'https://image.tmdb.org/t/p/w780',
    token: j['token'] ?? '',
  );
}

class AppUpdateConfig {
  final bool enabled;
  final bool forceUpdate;
  final String minVersion;
  final int minBuildNumber;
  final String updateTitle;
  final String updateMessage;
  final String buttonText;
  final String laterText;
  final String androidStoreUrl;
  final String appStoreUrl;
  final String privacyPolicy;
  final String termsAndCondition;
  final bool isIntroLoopActive;

  AppUpdateConfig({
    required this.enabled,
    required this.forceUpdate,
    required this.minVersion,
    required this.minBuildNumber,
    required this.updateTitle,
    required this.updateMessage,
    required this.buttonText,
    required this.laterText,
    required this.androidStoreUrl,
    required this.appStoreUrl,
    required this.privacyPolicy,
    required this.termsAndCondition,
    required this.isIntroLoopActive,
  });

  factory AppUpdateConfig.fromJson(Map<String, dynamic> j) =>
      AppUpdateConfig(
        enabled: j['enabled'] ?? false,
        forceUpdate: j['forceUpdate'] ?? false,
        minVersion: j['minVersion'] ?? '1.0.0',
        minBuildNumber: j['minBuildNumber'] ?? 1,
        updateTitle: j['updateTitle'] ?? 'Update Required',
        updateMessage: j['updateMessage'] ?? '',
        buttonText: j['buttonText'] ?? 'UPDATE',
        laterText: j['laterText'] ?? 'Later',
        androidStoreUrl: j['androidStoreUrl'] ?? '',
        appStoreUrl: j['appStoreUrl'] ?? '',
        privacyPolicy: j['privacy_policy'] ?? '',
        termsAndCondition: j['terms_and_condition'] ?? '',
        isIntroLoopActive: j['isIntroLoopActive'] ?? false,
      );
}

class WatchRedirect {
  final bool enabled;
  final String url;

  WatchRedirect({required this.enabled, required this.url});

  factory WatchRedirect.fromJson(Map<String, dynamic> j) => WatchRedirect(
    enabled: j['enabled'] ?? false,
    url: j['url'] ?? '',
  );
}

/// One ad-slot: isShow + list of ids.
class AdSlot {
  final bool isShow;
  final List<String> ids;

  AdSlot({required this.isShow, required this.ids});

  String pick({int index = 0}) {
    if (ids.isEmpty) return '';
    final i = index % ids.length;
    return ids[i];
  }

  factory AdSlot.fromJson(Map<String, dynamic> j) => AdSlot(
    isShow: j['isShow'] ?? false,
    ids: (j['id'] as List? ?? []).map((e) => e.toString()).toList(),
  );
}

class AdmobAdsIds {
  final AdSlot open;
  final AdSlot interstitial;
  final AdSlot native;
  final AdSlot reward;
  final AdSlot customBanner;

  AdmobAdsIds({
    required this.open,
    required this.interstitial,
    required this.native,
    required this.reward,
    required this.customBanner,
  });

  factory AdmobAdsIds.fromJson(Map<String, dynamic> j) {
    final ids = j['AdsIds'] as Map<String, dynamic>? ?? {};
    return AdmobAdsIds(
      open: AdSlot.fromJson(ids['open'] as Map<String, dynamic>? ?? {}),
      interstitial: AdSlot.fromJson(
          ids['interstitial'] as Map<String, dynamic>? ?? {}),
      native:
      AdSlot.fromJson(ids['native'] as Map<String, dynamic>? ?? {}),
      reward:
      AdSlot.fromJson(ids['reward'] as Map<String, dynamic>? ?? {}),
      customBanner: AdSlot.fromJson(
          ids['custom_banner'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CustomNativeAssets {
  final List<String> smallImages;
  final List<String> mediumImages;
  final List<String> ctaUrls;

  CustomNativeAssets({
    required this.smallImages,
    required this.mediumImages,
    required this.ctaUrls,
  });

  factory CustomNativeAssets.fromJson(Map<String, dynamic> j) =>
      CustomNativeAssets(
        smallImages:
        (j['smallImages'] as List? ?? []).map((e) => e.toString()).toList(),
        mediumImages: (j['mediumImages'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
        ctaUrls:
        (j['ctaUrls'] as List? ?? []).map((e) => e.toString()).toList(),
      );
}

class CustomBannerAssets {
  final List<String> images;
  final List<String> urls;

  CustomBannerAssets({required this.images, required this.urls});

  factory CustomBannerAssets.fromJson(Map<String, dynamic> j) =>
      CustomBannerAssets(
        images: (j['images'] as List? ?? []).map((e) => e.toString()).toList(),
        urls: (j['urls'] as List? ?? []).map((e) => e.toString()).toList(),
      );
}

class CustomInterstitialAssets {
  final List<String> urls;

  CustomInterstitialAssets({required this.urls});

  factory CustomInterstitialAssets.fromJson(Map<String, dynamic> j) =>
      CustomInterstitialAssets(
        urls: (j['urls'] as List? ?? []).map((e) => e.toString()).toList(),
      );
}

class CustomAds {
  final List<String> headlines;
  final List<String> descriptions;
  final List<String> buttonTexts;
  final String adBadgeText;
  final CustomNativeAssets native;
  final CustomBannerAssets banner;
  final CustomInterstitialAssets interstitial;

  CustomAds({
    required this.headlines,
    required this.descriptions,
    required this.buttonTexts,
    required this.adBadgeText,
    required this.native,
    required this.banner,
    required this.interstitial,
  });

  String headline(int i) => headlines.isEmpty
      ? 'Sponsored'
      : headlines[i % headlines.length];
  String description(int i) => descriptions.isEmpty
      ? ''
      : descriptions[i % descriptions.length];
  String buttonText(int i) =>
      buttonTexts.isEmpty ? 'Open' : buttonTexts[i % buttonTexts.length];

  factory CustomAds.fromJson(Map<String, dynamic> j) => CustomAds(
    headlines:
    (j['headlines'] as List? ?? []).map((e) => e.toString()).toList(),
    descriptions: (j['descriptions'] as List? ?? [])
        .map((e) => e.toString())
        .toList(),
    buttonTexts: (j['buttonTexts'] as List? ?? [])
        .map((e) => e.toString())
        .toList(),
    adBadgeText: j['adBadgeText'] ?? 'Ad',
    native: CustomNativeAssets.fromJson(
        j['native'] as Map<String, dynamic>? ?? {}),
    banner: CustomBannerAssets.fromJson(
        j['banner'] as Map<String, dynamic>? ?? {}),
    interstitial: CustomInterstitialAssets.fromJson(
        j['interstitial'] as Map<String, dynamic>? ?? {}),
  );
}

class NativeConfig {
  final String backgroundColor;
  final String fontColor;
  final String buttonColor;
  final String buttonFontColor;
  final double buttonBorderRadius;
  final double borderRadius;
  final int adSlotMinHeight;
  final int adSlotMaxHeight;
  final double mediaCornerRadius;
  final String adBadgeBackgroundColor;
  final String adBadgeFontColor;

  NativeConfig({
    required this.backgroundColor,
    required this.fontColor,
    required this.buttonColor,
    required this.buttonFontColor,
    required this.buttonBorderRadius,
    required this.borderRadius,
    required this.adSlotMinHeight,
    required this.adSlotMaxHeight,
    required this.mediaCornerRadius,
    required this.adBadgeBackgroundColor,
    required this.adBadgeFontColor,
  });

  factory NativeConfig.fromJson(Map<String, dynamic> j) => NativeConfig(
    backgroundColor: j['backgroundColor'] ?? '#1A2744',
    fontColor: j['fontColor'] ?? '#FFFFFF',
    buttonColor: j['buttonColor'] ?? '#168F84',
    buttonFontColor: j['buttonFontColor'] ?? '#FFFFFF',
    buttonBorderRadius:
    (j['buttonBorderRadius'] as num? ?? 18).toDouble(),
    borderRadius: (j['borderRadius'] as num? ?? 12).toDouble(),
    adSlotMinHeight: j['adSlotMinHeight'] ?? 120,
    adSlotMaxHeight: j['adSlotMaxHeight'] ?? 210,
    mediaCornerRadius:
    (j['mediaCornerRadius'] as num? ?? 12).toDouble(),
    adBadgeBackgroundColor:
    j['adBadgeBackgroundColor'] ?? '#FFCC66',
    adBadgeFontColor: j['adBadgeFontColor'] ?? '#FFFFFF',
  );
}

// ─────────────────────────────────────────────
//  Root config
// ─────────────────────────────────────────────

class AppConfig {
  final ApiData apiData;
  final AppUpdateConfig appUpdateConfig;
  final WatchRedirect watchRedirect;
  final bool preloadAds;
  final bool ondemandFallback;
  final int interstitialClickCount;
  final String primaryNetwork;
  final AdmobAdsIds admobAds;
  final CustomAds custom;
  final NativeConfig nativeConfig;

  AppConfig({
    required this.apiData,
    required this.appUpdateConfig,
    required this.watchRedirect,
    required this.preloadAds,
    required this.ondemandFallback,
    required this.interstitialClickCount,
    required this.primaryNetwork,
    required this.admobAds,
    required this.custom,
    required this.nativeConfig,
  });

  factory AppConfig.defaults() => AppConfig.fromJson({});

  factory AppConfig.fromJson(Map<String, dynamic> j) {
    final adsArr = j['admobAds'] as List? ?? [];

    // Safely extract the first ad-network entry, converting to Map<String,dynamic>
    Map<String, dynamic> firstAds = <String, dynamic>{};
    if (adsArr.isNotEmpty && adsArr.first is Map) {
      firstAds = Map<String, dynamic>.from(adsArr.first as Map);
    }

    return AppConfig(
      apiData: ApiData.fromJson(
          Map<String, dynamic>.from(j['ApiData'] as Map? ?? {})),
      appUpdateConfig: AppUpdateConfig.fromJson(
          Map<String, dynamic>.from(j['appUpdateConfig'] as Map? ?? {})),
      watchRedirect: WatchRedirect.fromJson(
          Map<String, dynamic>.from(j['watchRedirect'] as Map? ?? {})),
      preloadAds: j['preloadAds'] ?? true,
      ondemandFallback: j['ondemandFallback'] ?? true,
      interstitialClickCount: j['interstitialClickCount'] ?? 5,
      primaryNetwork: j['primaryNetwork'] ?? 'admob',
      admobAds: AdmobAdsIds.fromJson(firstAds),
      custom: CustomAds.fromJson(
          Map<String, dynamic>.from(j['custom'] as Map? ?? {})),
      nativeConfig: NativeConfig.fromJson(
          Map<String, dynamic>.from(j['nativeConfig'] as Map? ?? {})),
    );
  }
}

// ─────────────────────────────────────────────
//  Store (singleton)
// ─────────────────────────────────────────────

class AppConfigStore {
  AppConfigStore._();
  static final AppConfigStore instance = AppConfigStore._();

  static const _cacheKey = 'app_config_cache_v2';
  final _box = GetStorage();

  AppConfig _config = AppConfig.defaults();
  AppConfig get appConfig => _config;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Load from cache first (instant boot)
    final raw = _box.read(_cacheKey);
    if (raw != null) {
      try {
        final m = Map<String, dynamic>.from(
          jsonDecode(jsonEncode(raw)) as Map,
        );
        _config = AppConfig.fromJson(m);
      } catch (_) {}
    }
  }

  /// Call this after fetching from your backend / Remote Config.
  Future<void> apply(Map<String, dynamic> json) async {
    _config = AppConfig.fromJson(json);
    await _box.write(_cacheKey, json);
  }

  void overrideForTesting(AppConfig cfg) => _config = cfg;
}