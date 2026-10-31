import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/services/ads_service.dart';
import '../../data/services/app_config.dart';
import '../../data/services/launcher_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'onboarding_controller.dart';

class OnboardingFinalView extends StatelessWidget {
  const OnboardingFinalView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = OnboardingController.instance;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),

              // Success badge
              Center(
                child: Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.35),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 44.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Center(
                child: Obx(
                      () => Text(
                    'ALL SET${c.name.value.isNotEmpty ? ", ${c.name.value.toUpperCase()}" : ""}!',
                    textAlign: TextAlign.center,
                    style: T.h1.copyWith(
                      fontSize: 22.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  "Here's your profile",
                  style: T.body,
                ),
              ),
              SizedBox(height: 24.h),

              // Summary list
              Expanded(
                child: Obx(() {
                  final s = c.summary();
                  return SingleChildScrollView(
                    child: Column(
                      children: s.entries
                          .map(
                            (e) => _summary(
                          _iconFor(e.key),
                          e.key,
                          e.value,
                        ),
                      )
                          .toList(),
                    ),
                  );
                }),
              ),

              SizedBox(height: 12.h),

              // CTA
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () async {
                    c.saveAll();
                    AdsService.instance.resetOnboardingCycle();

                    final appCfg = AppConfigStore.instance.appConfig;
                    final introLoop = appCfg.appUpdateConfig.isIntroLoopActive;

                    // If intro-loop is enabled remotely, restart onboarding from the very first screen.
                    if (introLoop) {
                      Get.offAllNamed(Routes.OB_NAME_AGE);
                      return;
                    }

                    // Otherwise, go to Home.
                    Get.offAllNamed(Routes.HOME);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(R.pill),
                    ),
                  ),
                  child: Text(
                    'START WATCHING',
                    style: T.button.copyWith(
                      fontSize: 16.sp,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String label) {
    switch (label) {
      case 'Name':
        return Icons.person_outline;
      case 'Age':
        return Icons.cake_outlined;
      case 'Moods':
        return Icons.movie_filter_rounded;
      case 'Languages':
        return Icons.language_rounded;
      case 'Platforms':
        return Icons.theater_comedy_rounded;
      case 'Genres':
        return Icons.category_rounded;
      case 'Watch Time':
        return Icons.schedule_rounded;
      case 'Notifications':
        return Icons.notifications_rounded;
      case 'Content Rating':
        return Icons.shield_rounded;
      case 'Grid':
        return Icons.grid_view_rounded;
      default:
        return Icons.info_outline;
    }
  }

  Widget _summary(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(R.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20.sp),
          SizedBox(width: S.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: T.small.copyWith(
                    fontSize: 11.sp,
                    color: AppColors.textSub,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: T.title.copyWith(fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}