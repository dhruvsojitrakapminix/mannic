import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/onboarding_widgets.dart';
import 'onboarding_controller.dart';

class OnboardingPrivacyView extends StatelessWidget {
  const OnboardingPrivacyView({super.key});

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
              SizedBox(height: 32.h),
              Center(
                child: Text(
                  'YOUR PRIVACY',
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
                  "You're in control. Choose what we can access.",
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),

              Obx(
                    () => _privacyCard(
                  icon: Icons.analytics_outlined,
                  title: 'ANONYMOUS ANALYTICS',
                  desc:
                  'Help us improve by sharing crash reports and usage stats. No personal data.',
                  value: c.allowAnalytics.value,
                  onChanged: (v) => c.allowAnalytics.value = v,
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                    () => _privacyCard(
                  icon: Icons.auto_awesome,
                  title: 'PERSONALIZED RECOMMENDATIONS',
                  desc:
                  'Let us learn from your watch history to suggest better content.',
                  value: c.allowPersonalization.value,
                  onChanged: (v) => c.allowPersonalization.value = v,
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                    () => _privacyCard(
                  icon: Icons.location_on_outlined,
                  title: 'REGIONAL CONTENT',
                  desc:
                  'Use approximate location to show content available in your country.',
                  value: c.allowRegionDetection.value,
                  onChanged: (v) => c.allowRegionDetection.value = v,
                ),
              ),

              const Spacer(),

              // Trust note
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(R.md),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'All data stays on your device. We never sell your information.',
                        style: T.small.copyWith(
                          color: AppColors.primary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              PillButton(
                label: 'CONTINUE',
                enabled: true,
                onTap: () => Get.toNamed(Routes.OB_FINAL),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _privacyCard({
    required IconData icon,
    required String title,
    required String desc,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(R.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22.sp),
          SizedBox(width: S.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: T.title.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  desc,
                  style: T.small.copyWith(fontSize: 12.sp, height: 1.4),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}