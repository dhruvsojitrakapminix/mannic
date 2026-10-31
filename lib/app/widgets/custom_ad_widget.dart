import 'dart:io';

import 'package:bit_tv/app/data/services/app_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../data/services/ads_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Adaptive banner ad.
///
/// Usage:
/// ```dart
/// CustomAdWidget()
/// ```
/// It will silently collapse to `SizedBox.shrink()` if ads are
/// disabled, the unit ID is empty, or the load fails.
class CustomAdWidget extends StatefulWidget {
  final EdgeInsets margin;
  final bool showLoadingPlaceholder;

  const CustomAdWidget({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.showLoadingPlaceholder = true,
  });

  @override
  State<CustomAdWidget> createState() => _CustomAdWidgetState();
}

class _CustomAdWidgetState extends State<CustomAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final unitId = AppConfigStore.instance.appConfig.admobAds.native.ids.first;
    if (unitId.isEmpty) {
      setState(() => _failed = true);
      return;
    }

    final width = MediaQuery.of(context).size.width.truncate();
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );
    if (size == null) {
      setState(() => _failed = true);
      return;
    }

    final ad = BannerAd(
      adUnitId: unitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          if (!mounted) return;
          setState(() => _failed = true);
        },
      ),
    );

    await ad.load();
    if (!mounted) {
      ad.dispose();
      return;
    }
    setState(() => _ad = ad);
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return const SizedBox.shrink();
    if (!_loaded || _ad == null) {
      if (!widget.showLoadingPlaceholder) return const SizedBox.shrink();
      return Padding(
        padding: widget.margin,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              Platform.isAndroid ? 'Ad' : 'Ad',
              style: const TextStyle(color: AppColors.textHint),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: widget.margin,
      child: Center(
        child: SizedBox(
          width: _ad!.size.width.toDouble(),
          height: _ad!.size.height.toDouble(),
          child: AdWidget(ad: _ad!),
        ),
      ),
    );
  }
}

/// Inline ad used inside list views / grids.
///
/// Unlike [CustomAdWidget], this one never reserves space —
/// it returns `SizedBox.shrink()` until loaded.
/// Inline ad used inside list views / grids.
///
/// Unlike [CustomAdWidget], this one never reserves space —
/// it returns `SizedBox.shrink()` until loaded.
class InlineBannerAd extends StatelessWidget {
  final EdgeInsets margin;

  const InlineBannerAd({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: const CustomAdWidget(showLoadingPlaceholder: false),
    );
  }
}