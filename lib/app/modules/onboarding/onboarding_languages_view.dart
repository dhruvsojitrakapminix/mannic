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

class OnboardingLanguagesView extends StatelessWidget {
  const OnboardingLanguagesView({super.key});

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
                  'CHOOSE YOUR LANGUAGE',
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
                  'Pick a preferred language to continue.',
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(() {
                  return GridView.builder(
                    itemCount:
                    OnboardingController.availableLanguages.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 2.6,
                    ),
                    itemBuilder: (_, i) {
                      final l =
                      OnboardingController.availableLanguages[i];
                      final id = l['code']!;
                      final isSel = c.languages.contains(id);
                      return GestureDetector(
                        onTap: () => c.toggleLanguage(id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          alignment: Alignment.center,
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
                          child: Text(
                            l['name']!,
                            textAlign: TextAlign.center,
                            style: T.title.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.text,
                            ),
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
                  enabled: c.languages.isNotEmpty,
                  onTap: () => Get.toNamed(Routes.OB_PLATFORMS),
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