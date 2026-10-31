import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/services/app_config.dart';
import '../data/services/ads_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class NativeAdWidget extends StatefulWidget {
  final bool isSmall;

  const NativeAdWidget({super.key, this.isSmall = true});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _native;
  bool _loading = true;

  // Hardcoded default margin since it's no longer passed in
  final EdgeInsets _margin = const EdgeInsets.symmetric(vertical: 12);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final ad = await AdsService.instance.createNativeAd(isSmall: widget.isSmall);
      if (!mounted) {
        ad?.dispose();
        return;
      }
      setState(() {
        _native = ad;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _native?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isSmall ? 140 : 380,
      margin: EdgeInsets.fromLTRB(S.lg, S.xl, S.lg, S.md),
      child: (_loading)
          ? Padding(
              padding: _margin,
              child: _skeleton(),
            )
          : (_native != null)
              ? Padding(
                  padding: _margin,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(R.md),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 100.h),
                      child: AdWidget(ad: _native!),
                    ),
                  ),
                ) // Fallback custom native card
              : Padding(
                  padding: _margin,
                  child: _fallbackCard(),
                ),
    );
  }

  Widget _skeleton() {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(R.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Center(
        child: SizedBox(
          width: 20.r,
          height: 20.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _fallbackCard() {
    final cfg = AppConfigStore.instance.appConfig;
    final custom = cfg.custom;
    final nc = cfg.nativeConfig;

    // Hardcoded to 0 since variantIndex is removed
    const i = 0;

    final headline = custom.headline(i);
    final desc = custom.description(i);
    final cta = custom.buttonText(i);
    final img = custom.native.smallImages.isNotEmpty
        ? custom.native.smallImages[i % custom.native.smallImages.length]
        : '';

    final bg = _hex(nc.backgroundColor);
    final font = _hex(nc.fontColor);
    final btnBg = _hex(nc.buttonColor);
    final btnFont = _hex(nc.buttonFontColor);
    final badgeBg = _hex(nc.adBadgeBackgroundColor);
    final badgeFont = _hex(nc.adBadgeFontColor);
    final ctaUrl = custom.native.ctaUrls.isNotEmpty
        ? custom.native.ctaUrls[i % custom.native.ctaUrls.length]
        : '';

    return GestureDetector(
      onTap: () async {
        if (ctaUrl.isEmpty) return;
        final uri = Uri.tryParse(ctaUrl);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(nc.borderRadius.r),
        ),
        padding: EdgeInsets.all(S.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (img.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(nc.mediaCornerRadius.r),
                child: SizedBox(
                  width: 88.w,
                  height: 88.w,
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.card2),
                  ),
                ),
              ),
            SizedBox(width: S.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          custom.adBadgeText,
                          style: T.small.copyWith(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: badgeFont,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.title.copyWith(fontSize: 14.sp, color: font),
                  ),
                  if (desc.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: T.small.copyWith(fontSize: 11.sp, color: font.withOpacity(0.75)),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: btnBg,
                      borderRadius: BorderRadius.circular(nc.buttonBorderRadius.r),
                    ),
                    child: Text(
                      cta,
                      style: T.small.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: btnFont,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _hex(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    return Color(int.parse(h, radix: 16));
  }
}

/// Alias kept for compatibility.
class NativeCardAd extends StatelessWidget {
  const NativeCardAd({super.key});

  @override
  Widget build(BuildContext context) => const NativeAdWidget();
}
