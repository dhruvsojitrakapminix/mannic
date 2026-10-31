import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_config.dart';

class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  InterstitialAd? _interstitial;
  AppOpenAd? _appOpen;
  final Set<NativeAd> _activeNative = {};
  bool _appOpenShown = false;
  DateTime? _lastInterstitialTime;
  DateTime? _lastAppOpenTime;
  DateTime? _lastUserTap;
  int _openIdx = 0;
  int _interIdx = 0;
  int _nativeIdx = 0;

  AppConfig get _cfg => AppConfigStore.instance.appConfig;

  // ── Public ad-unit getters (rotate through JSON arrays) ──
  String get bannerUnitId =>
      Platform.isAndroid
          ? _cfg.admobAds.interstitial.pick()
          : _cfg.admobAds.interstitial.pick();

  String get interstitialUnitId =>
      _cfg.admobAds.interstitial.pick(index: _interIdx++);

  String get appOpenUnitId =>
      _cfg.admobAds.open.pick(index: _openIdx++);

  String get nativeUnitId =>
      _cfg.admobAds.native.pick(index: _nativeIdx++);

  String get rewardUnitId => _cfg.admobAds.reward.pick();

  bool get hasAppOpenReady => _appOpen != null;
  bool get hasInterstitialReady => _interstitial != null;

  void init() {
    if (_cfg.preloadAds) {
      _loadAppOpen();
      _loadInterstitial();
    }
  }

  // ── App Open ─────────────────────────────────────────
  void _loadAppOpen() {
    if (!_cfg.admobAds.open.isShow) return;
    final id = appOpenUnitId;
    if (id.isEmpty) return;

    AppOpenAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => _appOpen = ad,
        onAdFailedToLoad: (err) {
          debugPrint('AppOpen load failed: $err');
          _appOpen = null;
        },
      ),
    );
  }

  Future<void> showAppOpenIfReady() async {
    if (_appOpenShown) return;
    final ad = _appOpen;
    if (ad == null) {
      if (_cfg.ondemandFallback) _loadAppOpen();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _appOpen = null;
        _appOpenShown = true;
        _lastAppOpenTime = DateTime.now();
        if (_cfg.preloadAds) _loadAppOpen();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _appOpen = null;
        _loadAppOpen();
      },
    );
    await ad.show();
  }

  // ── Interstitial ─────────────────────────────────────
  void _loadInterstitial() {
    if (!_cfg.admobAds.interstitial.isShow) return;
    final id = interstitialUnitId;
    if (id.isEmpty) return;

    InterstitialAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (err) {
          debugPrint('Interstitial load failed: $err');
          _interstitial = null;
        },
      ),
    );
  }

  Future<void> maybeShowInterstitial() async {
    if (!_cfg.admobAds.interstitial.isShow) return;
    final now = DateTime.now();
    if (_lastInterstitialTime != null &&
        now.difference(_lastInterstitialTime!).inSeconds < 60) {
      return;
    }
    final ad = _interstitial;
    if (ad == null) {
      _loadInterstitial();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _interstitial = null;
        _lastInterstitialTime = DateTime.now();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _interstitial = null;
        _loadInterstitial();
      },
    );
    await ad.show();
  }

  // ── Native ───────────────────────────────────────────
  Future<NativeAd?> createNativeAd() async {
    if (!_cfg.admobAds.native.isShow) return null;
    final id = nativeUnitId;
    if (id.isEmpty) return null;

    final completer = Completer<NativeAd?>();
    final ad = NativeAd(
      adUnitId: id,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
      ),
      listener: NativeAdListener(
        onAdLoaded: (a) {
          final native = a as NativeAd;
          _activeNative.add(native);
          if (!completer.isCompleted) completer.complete(native);
        },
        onAdFailedToLoad: (a, err) {
          a.dispose();
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );
    ad.load();
    return completer.future;
  }

  // ── User-tap tracking ────────────────────────────────
  void onUserTap() {
    _lastUserTap = DateTime.now();
  }

  bool get userRecentlyTapped {
    if (_lastUserTap == null) return false;
    return DateTime.now().difference(_lastUserTap!).inSeconds < 5;
  }

  void resetOnboardingCycle() {
    _appOpenShown = false;
    _lastInterstitialTime = null;
    _lastAppOpenTime = null;
  }
}