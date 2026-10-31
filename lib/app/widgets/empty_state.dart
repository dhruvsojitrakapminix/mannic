import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: S.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96.r,
              height: 96.r,
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42.sp, color: AppColors.textHint),
            ),
            SizedBox(height: S.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: T.h3.copyWith(fontSize: 16.sp),
            ),
            if (subtitle != null) ...[
              SizedBox(height: S.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: T.body.copyWith(color: AppColors.textSub),
              ),
            ],
            if (action != null) ...[
              SizedBox(height: S.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}