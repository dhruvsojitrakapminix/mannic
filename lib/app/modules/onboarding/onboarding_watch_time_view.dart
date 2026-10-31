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

class OnboardingWatchTimeView extends StatelessWidget {
  const OnboardingWatchTimeView({super.key});

  static const _times = <Map<String, String>>[
    {'id': 'morning', 'name': 'Morning', 'icon': '🌅', 'range': '6 AM – 12 PM'},
    {'id': 'afternoon', 'name': 'Afternoon', 'icon': '☀️', 'range': '12 PM – 5 PM'},
    {'id': 'evening', 'name': 'Evening', 'icon': '🌆', 'range': '5 PM – 9 PM'},
    {'id': 'night', 'name': 'Night', 'icon': '🌙', 'range': '9 PM – 2 AM'},
  ];

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
                  'WHEN DO YOU WATCH?',
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
                  "We'll recommend content that fits your schedule.",
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(() {
                  return GridView.builder(
                    itemCount: _times.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (_, i) {
                      final t = _times[i];
                      final id = t['id']!;
                      final isSel = c.watchTimes.contains(id);
                      return GestureDetector(
                        onTap: () => c.toggleWatchTime(id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primary.withOpacity(0.12)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(R.lg),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: isSel ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t['icon']!,
                                style: TextStyle(fontSize: 36.sp),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                t['name']!.toUpperCase(),
                                style: T.h3.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isSel
                                      ? AppColors.primary
                                      : AppColors.text,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                t['range']!,
                                style: T.small.copyWith(fontSize: 11.sp),
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
                  enabled: c.watchTimes.isNotEmpty,
                  onTap: () => Get.toNamed(Routes.OB_NOTIF_TYPES),
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