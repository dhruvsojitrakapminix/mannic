import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_config.dart';

class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  // Interstitial state
  InterstitialAd? _interstitial;
  bool _isLoadingInterstitial = false;
  List<String> _interstitialIds = [];
  int _currentInterstitialIdIndex = 0;

  // App Open state
  AppOpenAd? _appOpen;
  bool _isLoadingAppOpen = false;
  List<String> _appOpenIds = [];
  int _currentAppOpenIdIndex = 0;

  // Native
  final Set<NativeAd> _activeNative = {};
  int _nativeIdx = 0;

  // Click Tracking
  int _clickCount = 0;
  bool _hasShownInterstitialThisCycle = false;
  DateTime? _lastUserTap;

  // Fallback Flags
  bool interstitialAllFailed = false;
  bool appOpenAllFailed = false;

  AppConfig get _cfg => AppConfigStore.instance.appConfig;

  // ── PUBLIC GETTERS (FIXES YOUR ERRORS) ───────────────
  bool get hasAppOpenReady => _appOpen != null;
  bool get hasInterstitialReady => _interstitial != null;

  // Added back for custom_ad_widget.dart
  String get bannerUnitId => _cfg.admobAds.interstitial.pick();

  String get rewardUnitId => _cfg.admobAds.reward.pick();
  String get nativeUnitId => _cfg.admobAds.native.pick(index: _nativeIdx++);

  // ── INITIALIZATION ───────────────────────────────────
  void init() {
    if (_cfg.preloadAds) {
      _loadAppOpen();
      _loadInterstitial();
    }
  }

  // ── SMART LOADER: INTERSTITIAL ───────────────────────
  void _loadInterstitial() {
    if (!_cfg.admobAds.interstitial.isShow || _isLoadingInterstitial) return;

    _isLoadingInterstitial = true;
    interstitialAllFailed = false;

    // Assuming your config has a list of IDs called 'ids'.
    // If it's called something else (like 'list'), change it here.
    _interstitialIds = _cfg.admobAds.interstitial.ids.isNotEmpty
        ? _cfg.admobAds.interstitial.ids
        : [];

    if (_interstitialIds.isEmpty) {
      interstitialAllFailed = true;
      _isLoadingInterstitial = false;
      return;
    }

    _currentInterstitialIdIndex = 0;
    _tryLoadInterstitialById();
  }

  void _tryLoadInterstitialById() {
    if (_currentInterstitialIdIndex >= _interstitialIds.length) {
      debugPrint('ALL Interstitial IDs failed. Fallback required.');
      interstitialAllFailed = true;
      _isLoadingInterstitial = false;
      _interstitial = null;
      return;
    }

    final id = _interstitialIds[_currentInterstitialIdIndex];
    debugPrint('Trying Interstitial ID: $id');

    InterstitialAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _isLoadingInterstitial = false;
          interstitialAllFailed = false;
          debugPrint('Interstitial loaded successfully: $id');
        },
        onAdFailedToLoad: (err) {
          debugPrint('Interstitial ID $id failed: $err');
          _currentInterstitialIdIndex++;
          _tryLoadInterstitialById(); // Try next ID
        },
      ),
    );
  }

  // ── SHOW INTERSTITIAL (Triggered by Click) ───────────
  Future<void> showInterstitialIfReady() async {
    if (_hasShownInterstitialThisCycle) return; // Only once per 5 clicks

    if (interstitialAllFailed) {
      debugPrint('Triggering custom banner fallback');
      // Trigger your custom URL launcher logic here
      final ctaUrls = _cfg.custom.native.ctaUrls;
      if (ctaUrls.isNotEmpty) {
        final url = ctaUrls.first;
        final uri = Uri.tryParse(url);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
      return;
    }

    if (_interstitial == null) {
      if (_cfg.ondemandFallback) _loadInterstitial();
      return;
    }

    _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _interstitial = null;
        _hasShownInterstitialThisCycle = true; // Mark as shown
        if (_cfg.preloadAds) _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _interstitial = null;
        if (_cfg.preloadAds) _loadInterstitial();
      },
    );

    await _interstitial!.show();
  }

  // ── SMART LOADER: APP OPEN ───────────────────────────
  void _loadAppOpen() {
    if (!_cfg.admobAds.open.isShow || _isLoadingAppOpen) return;

    _isLoadingAppOpen = true;
    appOpenAllFailed = false;

    _appOpenIds = _cfg.admobAds.open.ids.isNotEmpty
        ? _cfg.admobAds.open.ids
        : [];

    if (_appOpenIds.isEmpty) {
      appOpenAllFailed = true;
      _isLoadingAppOpen = false;
      return;
    }

    _currentAppOpenIdIndex = 0;
    _tryLoadAppOpenById();
  }

  void _tryLoadAppOpenById() {
    if (_currentAppOpenIdIndex >= _appOpenIds.length) {
      debugPrint('ALL App Open IDs failed.');
      appOpenAllFailed = true;
      _isLoadingAppOpen = false;
      _appOpen = null;
      return;
    }

    final id = _appOpenIds[_currentAppOpenIdIndex];
    debugPrint('Trying App Open ID: $id');

    AppOpenAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpen = ad;
          _isLoadingAppOpen = false;
          appOpenAllFailed = false;
        },
        onAdFailedToLoad: (err) {
          _currentAppOpenIdIndex++;
          _tryLoadAppOpenById(); // Try next ID
        },
      ),
    );
  }

  // Add this variable at the top of your AdsService class
  bool _hasAppOpenShownInSession = false;

  Future<void> showAppOpenIfReady() async {
    // 1. If it's already been shown this session, do nothing.
    if (_hasAppOpenShownInSession) return;

    if (_appOpen == null) {
      if (_cfg.ondemandFallback) _loadAppOpen();
      return;
    }

    // 2. Mark as shown immediately before displaying
    _hasAppOpenShownInSession = true;

    _appOpen!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _appOpen = null;
        // We do NOT reset _hasAppOpenShownInSession here.
        // So it won't show again when the app is resumed.
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _appOpen = null;
        // Even if it fails to show, we keep it marked as shown to avoid
        // spamming the user with failed attempts.
      },
    );

    await _appOpen!.show();
  }

  // ── NATIVE ───────────────────────────────────────────
  Future<NativeAd?> createNativeAd({required bool isSmall}) async {
    debugPrint('start Load 1');
    if (!_cfg.admobAds.native.isShow) return null;
    final id = nativeUnitId;
    if (id.isEmpty) return null;
    debugPrint('start Load 2');
    final completer = Completer<NativeAd?>();
    debugPrint('start Load 3');
    final ad = NativeAd(
      adUnitId: id,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(templateType: isSmall ? TemplateType.small : TemplateType.medium),
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
      ),
      listener: NativeAdListener(
        onAdLoaded: (a) {
          final native = a as NativeAd;
          _activeNative.add(native);
          debugPrint('Native loaded successfully: $id');
          if (!completer.isCompleted) completer.complete(native);
        },
        onAdFailedToLoad: (a, err) {
          a.dispose();
          debugPrint('Native loaded successfully: $id');
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );
    debugPrint('start Load 4');
    ad.load();
    return completer.future;
  }

  // ── CLICK TRACKING (EVERY 5 CLICKS) ──────────────────
  void onUserTap() {
    _lastUserTap = DateTime.now();

    _clickCount++;

    // Reset cycle after hitting 5
    if (_clickCount > 5) {
      _clickCount = 1;
      _hasShownInterstitialThisCycle = false;
    }

    // Trigger exactly on the 5th click
    if (_clickCount == 5 && !_hasShownInterstitialThisCycle) {
      showInterstitialIfReady();
    }
  }

  bool get userRecentlyTapped {
    if (_lastUserTap == null) return false;
    return DateTime.now().difference(_lastUserTap!).inSeconds < 5;
  }

  void resetOnboardingCycle() {
    _clickCount = 0;
    _hasShownInterstitialThisCycle = false;
  }
}