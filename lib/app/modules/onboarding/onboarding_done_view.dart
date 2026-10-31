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

/// Terminal onboarding screen — shown when the flow is done.
/// Most users never land here because [OnboardingFinalView]
/// calls [Get.offAllNamed] directly, but it's kept as a safe
/// fallback / deep-link destination.
class OnboardingDoneView extends StatelessWidget {
  const OnboardingDoneView({super.key});

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
              const Spacer(),

              Center(
                child: Container(
                  width: 96.r,
                  height: 96.r,
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
                    Icons.rocket_launch_rounded,
                    color: AppColors.primary,
                    size: 48.sp,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Center(
                child: Text(
                  "YOU'RE READY!",
                  textAlign: TextAlign.center,
                  style: T.h1.copyWith(
                    fontSize: 22.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Your personalized experience is set up.\nEnjoy unlimited movies, shows, and more.',
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 32.h),

              const Spacer(),

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
                    'START EXPLORING',
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
}