import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A single selectable card with optional emoji/icon, title, subtitle.
class OptionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? leading;
  final IconData? leadingIcon;
  final bool selected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.card,
          borderRadius: BorderRadius.circular(R.lg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 16,
              spreadRadius: -4,
            ),
          ]
              : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              Text(leading!, style: TextStyle(fontSize: 24.sp)),
              SizedBox(width: 14.w),
            ] else if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                color: selected ? AppColors.primary : AppColors.textSub,
                size: 22.sp,
              ),
              SizedBox(width: S.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: T.h3.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: selected ? AppColors.primary : AppColors.text,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: T.small.copyWith(
                          fontSize: 12.sp, color: AppColors.textSub),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}

/// Rounded pill bottom button used across all onboarding screens.
class PillButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const PillButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.card2,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.textHint,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(R.pill),
          ),
        ),
        child: Text(
          label,
          style: T.button.copyWith(fontSize: 16.sp, letterSpacing: 1.2),
        ),
      ),
    );
  }
}