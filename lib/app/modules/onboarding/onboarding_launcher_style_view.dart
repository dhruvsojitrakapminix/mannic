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

class OnboardingLauncherStyleView extends StatelessWidget {
  const OnboardingLauncherStyleView({super.key});

  static const _gridOptions = [
    {'id': 4, 'label': '4 × 5', 'desc': 'Bigger icon'},
    {'id': 5, 'label': '5 × 6', 'desc': 'Balanced (default)'},
    {'id': 6, 'label': '6 × 8', 'desc': 'Compact, more apps'},
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
                  'LAUNCHER STYLE',
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
                  'Choose your home screen grid size.',
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),

              // ── Grid options ──────────────────
              Obx(() {
                final selected = c.gridColumns.value;
                return Column(
                  children: _gridOptions.map((g) {
                    final isSel = selected == g['id'];
                    return GestureDetector(
                      onTap: () =>
                      c.gridColumns.value = g['id'] as int,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
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
                            SizedBox(
                              width: 40.r,
                              height: 40.r,
                              child: GridView.builder(
                                physics:
                                const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: g['id'] as int,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                ),
                                itemCount: (g['id'] as int) * 2,
                                itemBuilder: (_, i) => Container(
                                  decoration: BoxDecoration(
                                    color: isSel
                                        ? AppColors.primary
                                        : AppColors.textHint,
                                    borderRadius:
                                    BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g['label'] as String,
                                    style: T.h3.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
                                      color: isSel
                                          ? AppColors.primary
                                          : AppColors.text,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    g['desc'] as String,
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
                  }).toList(),
                );
              }),

              SizedBox(height: 8.h),

              // ── Dock toggle ───────────────────
              Text(
                'DOCK VISIBILITY',
                style: T.small.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                    () => SwitchListTile(
                  value: c.showDock.value,
                  onChanged: (v) => c.showDock.value = v,
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Show bottom dock',
                    style: T.title.copyWith(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    'Quick access to your most-used apps',
                    style: T.small.copyWith(fontSize: 11.sp),
                  ),
                ),
              ),

              const Spacer(),

              PillButton(
                label: 'CONTINUE',
                enabled: true,
                onTap: () => Get.toNamed(Routes.OB_PRIVACY),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}