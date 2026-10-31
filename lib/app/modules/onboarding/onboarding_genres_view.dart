import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/services/install_source_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/onboarding_widgets.dart';
import 'onboarding_controller.dart';

class OnboardingGenresView extends StatelessWidget {
  const OnboardingGenresView({super.key});

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
                  'FAVOURITE GENRES?',
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
                  "Pick a few — we'll recommend based on these.",
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(
                      () => SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 10.h,
                      children:
                      OnboardingController.availableGenres.map((g) {
                        final id = g['id'] as int;
                        final sel = c.genres.contains(id);
                        return GestureDetector(
                          onTap: () => c.toggleGenre(id),
                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 11.h,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.card,
                              borderRadius:
                              BorderRadius.circular(R.pill),
                              border: Border.all(
                                color: sel
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  g['icon'] as String,
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  g['name'] as String,
                                  style: T.chip.copyWith(
                                    color: sel
                                        ? Colors.white
                                        : AppColors.text,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Obx(
                    () => PillButton(
                  label: 'CONTINUE',
                  enabled: c.genres.isNotEmpty,
                  onTap: () {
                    final marketing = InstallSourceService
                        .instance.info?.isMarketing ??
                        false;
                    if (marketing) {
                      Get.toNamed(Routes.OB_WATCH_TIME);
                    } else {
                      Get.toNamed(Routes.OB_FINAL);
                    }
                  },
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