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

class OnboardingNotifTypesView extends StatelessWidget {
  const OnboardingNotifTypesView({super.key});

  static const _types = <Map<String, dynamic>>[
    {
      'id': 'new_releases',
      'name': 'NEW RELEASES',
      'desc': 'When new movies & shows are added',
      'icon': Icons.new_releases_rounded,
    },
    {
      'id': 'trending',
      'name': 'TRENDING NOW',
      'desc': 'Weekly trending content digest',
      'icon': Icons.local_fire_department,
    },
    {
      'id': 'recommendations',
      'name': 'PERSONALIZED PICKS',
      'desc': 'Based on your watch history',
      'icon': Icons.auto_awesome,
    },
    {
      'id': 'reminders',
      'name': 'REMINDERS',
      'desc': 'For titles in your watchlist',
      'icon': Icons.notifications_active_rounded,
    },
    {
      'id': 'promotions',
      'name': 'OFFERS & PROMOTIONS',
      'desc': 'Special deals from streaming apps',
      'icon': Icons.local_offer_rounded,
    },
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
                  'NOTIFICATION TYPES',
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
                  'Choose what we notify you about.',
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(() {
                  return ListView.separated(
                    itemCount: _types.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) {
                      final t = _types[i];
                      final id = t['id'] as String;
                      final isSel = c.notifTypes.contains(id);
                      return GestureDetector(
                        onTap: () => c.toggleNotifType(id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
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
                              Icon(
                                t['icon'] as IconData,
                                color: isSel
                                    ? AppColors.primary
                                    : AppColors.textSub,
                                size: 22.sp,
                              ),
                              SizedBox(width: S.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t['name'] as String,
                                      style: T.title.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.3,
                                        color: isSel
                                            ? AppColors.primary
                                            : AppColors.text,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      t['desc'] as String,
                                      style: T.small.copyWith(
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 180),
                                width: 22.r,
                                height: 22.r,
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: isSel
                                        ? AppColors.primary
                                        : AppColors.divider,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSel
                                    ? Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 14.sp,
                                )
                                    : null,
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
                  enabled: c.notifTypes.isNotEmpty,
                  onTap: () => Get.toNamed(Routes.OB_MATURITY),
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