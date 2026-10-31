import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/onboarding_widgets.dart';
import 'onboarding_controller.dart';

class OnboardingMoodsView extends StatelessWidget {
  const OnboardingMoodsView({super.key});

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
                  "WHAT'S YOUR VIBE?",
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
                  "Pick a flavor — you'll still get everything else.",
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(() {
                  final selected = c.moods.toList();
                  return ListView.separated(
                    itemCount: OnboardingController.availableMoods.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) {
                      final m = OnboardingController.availableMoods[i];
                      final id = m['id']!;
                      final isSel = c.moods.contains(id);
                      return OptionCard(
                        title: m['name']!.toUpperCase(),
                        subtitle:
                        'Curated ${m['name']!.toLowerCase()} content',
                        leading: m['icon'],
                        selected: isSel,
                        onTap: () => c.toggleMood(id),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 16.h),
              Obx(
                    () => PillButton(
                  label: 'CONTINUE',
                  enabled: c.moods.isNotEmpty,
                  onTap: () => Get.toNamed(Routes.OB_LANGUAGES),
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