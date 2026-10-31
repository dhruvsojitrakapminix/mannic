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

class OnboardingMaturityView extends StatelessWidget {
  const OnboardingMaturityView({super.key});

  static const _levels = <Map<String, String>>[
    {'id': 'kids', 'name': 'KIDS', 'desc': 'Family-friendly content only'},
    {'id': 'teen', 'name': 'TEEN', 'desc': 'Ages 13+ content'},
    {'id': 'adult', 'name': 'ADULT', 'desc': 'Mature content, no restrictions'},
    {'id': 'family', 'name': 'FAMILY SAFE', 'desc': 'Mixed family viewing'},
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
                  'CONTENT MATURITY',
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
                  'Filter what appears in your feed. Change anytime in Settings.',
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(() {
                  final sel = c.maturityLevel.value;
                  return ListView.separated(
                    itemCount: _levels.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) {
                      final l = _levels[i];
                      final isSel = sel == l['id'];
                      return GestureDetector(
                        onTap: () =>
                        c.maturityLevel.value = l['id'] as String,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: EdgeInsets.all(18.w),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l['name']!,
                                      style: T.h3.copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.3,
                                        color: isSel
                                            ? AppColors.primary
                                            : AppColors.text,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      l['desc']!,
                                      style: T.small
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSel)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 22.sp,
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
                  label: 'CONTINUE',
                  enabled: c.maturityLevel.value.isNotEmpty,
                  onTap: () => Get.toNamed(Routes.OB_LAUNCHER_STYLE),
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