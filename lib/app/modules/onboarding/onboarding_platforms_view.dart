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

class OnboardingPlatformsView extends StatelessWidget {
  const OnboardingPlatformsView({super.key});

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
                  'WHICH PLATFORMS?',
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
                  'Select streaming services you have.',
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(() {
                  c.platforms.toList();
                  return GridView.builder(
                    itemCount:
                    OnboardingController.availablePlatforms.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 2.4,
                    ),
                    itemBuilder: (_, i) {
                      final p =
                      OnboardingController.availablePlatforms[i];
                      final id = p['id']!;
                      final isSel = c.platforms.contains(id);
                      return GestureDetector(
                        onTap: () => c.togglePlatform(id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding:
                          EdgeInsets.symmetric(horizontal: 14.w),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primary.withOpacity(0.12)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(R.md),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: isSel ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                p['icon']!,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  p['name']!,
                                  style: T.title.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: isSel
                                        ? AppColors.primary
                                        : AppColors.text,
                                  ),
                                ),
                              ),
                              if (isSel)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 18.sp,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 16.h),
              Obx(
                    () => PillButton(
                  label: 'NEXT',
                  enabled: c.platforms.isNotEmpty,
                  onTap: () => Get.toNamed(Routes.OB_GENRES),
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