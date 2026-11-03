import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/services/ads_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class LauncherView extends StatefulWidget {
  const LauncherView({super.key});

  @override
  State<LauncherView> createState() => _LauncherViewState();
}

class _LauncherViewState extends State<LauncherView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );

    _ctrl.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final started = DateTime.now();

    // Wait up to 2.5s for app-open ad, then attempt to show it
    int tries = 0;
    while (tries < 25 && !AdsService.instance.hasAppOpenReady) {
      await Future.delayed(const Duration(milliseconds: 100));
      tries++;
    }
    await AdsService.instance.showAppOpenIfReady();

    // Ensure minimum 2s display
    final elapsed = DateTime.now().difference(started);
    final remaining = const Duration(milliseconds: 2000) - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (!mounted) return;
    _goNext();
  }

  void _goNext() {
    final box = GetStorage();
    final onboardingDone = box.read<bool>('onboarding_done') ?? false;

    if (onboardingDone) {
      Get.offAllNamed(
        Routes.HOME,
      );
    } else {
      Get.offAllNamed(
        Routes.OB_NAME_AGE,
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Radial glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    AppColors.primary.withOpacity(0.18),
                    AppColors.bg,
                  ],
                ),
              ),
            ),
          ),

          // Center logo + brand
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 108.r,
                        height: 108.r,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(26.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.45),
                              blurRadius: 40,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 66.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Super Tv',
                        textAlign: TextAlign.center,
                        style: T.h1.copyWith(
                          fontSize: 25.sp,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Movies • TV • Short Drama',
                        style: T.small.copyWith(letterSpacing: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom loader
          Positioned(
            bottom: 60.h,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                children: [
                  SizedBox(
                    width: 26.r,
                    height: 26.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading your experience…',
                    style: T.small.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}