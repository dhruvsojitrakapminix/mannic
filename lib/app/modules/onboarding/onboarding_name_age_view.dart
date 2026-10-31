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

class OnboardingNameAgeView extends StatelessWidget {
  const OnboardingNameAgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = OnboardingController.instance;
    final nameCtrl = TextEditingController(text: c.name.value);
    final ageCtrl = TextEditingController(
      text: c.age.value == null ? '' : c.age.value.toString(),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),
              Center(
                child: Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 42.sp,
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              Center(
                child: Text(
                  'TELL US ABOUT YOU',
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
                  "We'll personalize your experience.",
                  textAlign: TextAlign.center,
                  style: T.body,
                ),
              ),
              SizedBox(height: 40.h),
              const _Label('YOUR NAME'),
              SizedBox(height: 8.h),
              _Input(
                controller: nameCtrl,
                hint: 'e.g. Dhruv',
                onChanged: (v) => c.name.value = v.trim(),
              ),
              SizedBox(height: 20.h),
              const _Label('YOUR AGE'),
              SizedBox(height: 8.h),
              _Input(
                controller: ageCtrl,
                hint: 'e.g. 22',
                keyboard: TextInputType.number,
                onChanged: (v) => c.age.value =
                    int.tryParse(v.replaceAll(RegExp(r'\D'), '')),
              ),
              const Spacer(),
              Obx(() {
                final ok = c.name.value.trim().length >= 2 &&
                    c.age.value != null &&
                    c.age.value! >= 5 &&
                    c.age.value! <= 99;
                return PillButton(
                  label: 'CONTINUE',
                  enabled: ok,
                  onTap: () => Get.toNamed(Routes.OB_MOODS),
                );
              }),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: T.small.copyWith(
      fontSize: 12.sp,
      color: AppColors.textSub,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    ),
  );
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;

  const _Input({
    required this.controller,
    required this.hint,
    this.keyboard,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboard,
    onChanged: onChanged,
    style: T.h3.copyWith(fontSize: 17.sp, color: AppColors.text),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: T.body.copyWith(color: AppColors.textHint),
      filled: true,
      fillColor: AppColors.card,
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(R.lg),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(R.lg),
        borderSide:
        const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );
}