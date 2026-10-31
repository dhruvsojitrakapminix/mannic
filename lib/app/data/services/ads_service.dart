import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_config.dart';

class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  // ── Interstitial ────────────────────────────────────
  InterstitialAd? _interstitial;
  bool _isLoadingInterstitial = false;
  List<String> _interstitialIds = [];
  int _currentInterstitialIdIndex = 0;

  // ── App Open ────────────────────────────────────────
  AppOpenAd? _appOpen;
  bool _isLoadingAppOpen = false;
  List<String> _appOpenIds = [];
  int _currentAppOpenIdIndex = 0;
  bool _hasAppOpenShownInSession = false;

  // ── Reward ──────────────────────────────────────────
  RewardedAd? _reward;
  bool _isLoadingReward = false;
  List<String> _rewardIds = [];
  int _currentRewardIdIndex = 0;

  // ── Native ──────────────────────────────────────────
  final Set<NativeAd> _activeNative = {};
  int _nativeIdx = 0;

  // ── Click-cycle state ───────────────────────────────
  static const int _clickStep = 5; // how often we trigger (every 5 taps)
  int _clickCount = 0;              // total taps since last reward
  int _cycleNumber = 0;             // how many 5-click cycles completed
  int _cycleTarget = 4;             // random N (2..6): the cycle that becomes a reward
  bool _showingInCycle = false;     // guard while an ad is displaying
  DateTime? _lastUserTap;

  // ── Fallback flags ──────────────────────────────────
  bool interstitialAllFailed = false;
  bool appOpenAllFailed = false;
  bool rewardAllFailed = false;

  AppConfig get _cfg => AppConfigStore.instance.appConfig;

  // ── Public getters ──────────────────────────────────
  bool get hasAppOpenReady => _appOpen != null;
  bool get hasInterstitialReady => _interstitial != null;
  bool get hasRewardReady => _reward != null;

  String get bannerUnitId => _cfg.admobAds.interstitial.pick();
  String get rewardUnitId => _cfg.admobAds.reward.pick();
  String get nativeUnitId =>
      _cfg.admobAds.native.pick(index: _nativeIdx++);

  // ── Init ────────────────────────────────────────────
  void init() {
    _cycleTarget = _rollTarget();
    debugPrint('[Ads] Init — reward triggers on cycle #$_cycleTarget '
        '(i.e. at click ${_cycleTarget * _clickStep})');
    if (_cfg.preloadAds) {
      _loadAppOpen();
      _loadInterstitial();
      _loadReward();
    }
  }

  int _rollTarget() {
    // Random integer in [2, 6]
    return 2 + Random().nextInt(5);
  }

  // ── Interstitial loader ─────────────────────────────
  void _loadInterstitial() {
    if (!_cfg.admobAds.interstitial.isShow || _isLoadingInterstitial) {
      return;
    }
    _isLoadingInterstitial = true;
    interstitialAllFailed = false;
    _interstitialIds = _cfg.admobAds.interstitial.ids.isNotEmpty
        ? List<String>.from(_cfg.admobAds.interstitial.ids)
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
      debugPrint('[Ads] All Interstitial IDs failed.');
      interstitialAllFailed = true;
      _isLoadingInterstitial = false;
      _interstitial = null;
      return;
    }
    final id = _interstitialIds[_currentInterstitialIdIndex];
    InterstitialAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _isLoadingInterstitial = false;
          interstitialAllFailed = false;
          debugPrint('[Ads] Interstitial loaded: $id');
        },
        onAdFailedToLoad: (err) {
          _currentInterstitialIdIndex++;
          _tryLoadInterstitialById();
        },
      ),
    );
  }

  // ── App Open loader ─────────────────────────────────
  void _loadAppOpen() {
    if (!_cfg.admobAds.open.isShow || _isLoadingAppOpen) return;
    _isLoadingAppOpen = true;
    appOpenAllFailed = false;
    _appOpenIds = _cfg.admobAds.open.ids.isNotEmpty
        ? List<String>.from(_cfg.admobAds.open.ids)
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
      appOpenAllFailed = true;
      _isLoadingAppOpen = false;
      _appOpen = null;
      return;
    }
    final id = _appOpenIds[_currentAppOpenIdIndex];
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
          _tryLoadAppOpenById();
        },
      ),
    );
  }

  // ── Reward loader ───────────────────────────────────
  void _loadReward() {
    if (!_cfg.admobAds.reward.isShow || _isLoadingReward) return;
    _isLoadingReward = true;
    rewardAllFailed = false;
    _rewardIds = _cfg.admobAds.reward.ids.isNotEmpty
        ? List<String>.from(_cfg.admobAds.reward.ids)
        : [];
    if (_rewardIds.isEmpty) {
      rewardAllFailed = true;
      _isLoadingReward = false;
      return;
    }
    _currentRewardIdIndex = 0;
    _tryLoadRewardById();
  }

  void _tryLoadRewardById() {
    if (_currentRewardIdIndex >= _rewardIds.length) {
      debugPrint('[Ads] All Reward IDs failed.');
      rewardAllFailed = true;
      _isLoadingReward = false;
      _reward = null;
      return;
    }
    final id = _rewardIds[_currentRewardIdIndex];
    RewardedAd.load(
      adUnitId: id,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _reward = ad;
          _isLoadingReward = false;
          rewardAllFailed = false;
          debugPrint('[Ads] Reward loaded: $id');
        },
        onAdFailedToLoad: (err) {
          _currentRewardIdIndex++;
          _tryLoadRewardById();
        },
      ),
    );
  }

  // ── Show App Open ───────────────────────────────────
  Future<void> showAppOpenIfReady() async {
    if (_hasAppOpenShownInSession) return;
    if (_appOpen == null) {
      if (_cfg.ondemandFallback) _loadAppOpen();
      return;
    }
    _hasAppOpenShownInSession = true;
    _appOpen!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _appOpen = null;
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _appOpen = null;
      },
    );
    await _appOpen!.show();
  }

  // ── Show one Interstitial ───────────────────────────
  Future<void> _showInterstitial() async {
    // custom fallback if all IDs failed
    if (interstitialAllFailed) {
      final urls = _cfg.custom.native.ctaUrls;
      if (urls.isNotEmpty) {
        final uri = Uri.tryParse(urls.first);
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

    final completer = Completer<void>();
    _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _interstitial = null;
        if (_cfg.preloadAds) _loadInterstitial();
        if (!completer.isCompleted) completer.complete();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _interstitial = null;
        if (_cfg.preloadAds) _loadInterstitial();
        if (!completer.isCompleted) completer.complete();
      },
    );
    await _interstitial!.show();
    return completer.future;
  }

  // ── Show one Reward ─────────────────────────────────
  Future<void> _showReward() async {
    if (rewardAllFailed) return;
    if (_reward == null) {
      if (_cfg.ondemandFallback) _loadReward();
      return;
    }

    final completer = Completer<void>();
    _reward!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _reward = null;
        if (_cfg.preloadAds) _loadReward();
        if (!completer.isCompleted) completer.complete();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _reward = null;
        if (_cfg.preloadAds) _loadReward();
        if (!completer.isCompleted) completer.complete();
      },
    );
    await _reward!.show(
      onUserEarnedReward: (_, reward) {
        debugPrint('[Ads] Reward earned: ${reward.amount} ${reward.type}');
      },
    );
    return completer.future;
  }

  // ── Main click handler ──────────────────────────────
  void onUserTap() {
    _lastUserTap = DateTime.now();

    // While an ad is displaying, ignore taps
    if (_showingInCycle) return;

    _clickCount++;
    debugPrint('[Ads] Tap $_clickCount '
        '(cycle ${_cycleNumber + 1}/$_cycleTarget)');

    // Not yet at a 5-tap boundary
    if (_clickCount % _clickStep != 0) return;

    // We hit a 5-tap boundary
    _cycleNumber++;
    debugPrint('[Ads] Reached click $_clickCount — cycle #$_cycleNumber');

    if (_cycleNumber < _cycleTarget) {
      // Regular interstitial for cycles 1..(target-1)
      _runCycleAd(isReward: false);
    } else if (_cycleNumber == _cycleTarget) {
      // The target cycle → show reward, then reset everything
      _runCycleAd(isReward: true, resetAfter: true);
    }
  }

  Future<void> _runCycleAd({
    required bool isReward,
    bool resetAfter = false,
  }) async {
    _showingInCycle = true;
    try {
      if (isReward) {
        debugPrint('[Ads] Showing REWARD (cycle #$_cycleNumber)');
        await _showReward();
      } else {
        debugPrint('[Ads] Showing INTERSTITIAL (cycle #$_cycleNumber)');
        await _showInterstitial();
      }
    } finally {
      _showingInCycle = false;

      if (resetAfter) {
        _resetCycle();
      }
    }
  }

  void _resetCycle() {
    _clickCount = 0;
    _cycleNumber = 0;
    _cycleTarget = _rollTarget();
    debugPrint('[Ads] Cycle reset — new target = $_cycleTarget '
        '(reward at click ${_cycleTarget * _clickStep})');
  }

  // ── Reset from onboarding ───────────────────────────
  void resetOnboardingCycle() {
    _resetCycle();
  }

  bool get userRecentlyTapped {
    if (_lastUserTap == null) return false;
    return DateTime.now().difference(_lastUserTap!).inSeconds < 5;
  }

  // ── Native (unchanged) ──────────────────────────────
  Future<NativeAd?> createNativeAd({required bool isSmall}) async {
    if (!_cfg.admobAds.native.isShow) return null;
    final id = nativeUnitId;
    if (id.isEmpty) return null;

    final completer = Completer<NativeAd?>();
    final ad = NativeAd(
      adUnitId: id,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: isSmall ? TemplateType.small : TemplateType.medium,
      ),
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
}