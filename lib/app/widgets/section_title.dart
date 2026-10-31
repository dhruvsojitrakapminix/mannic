import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showArrow;
  final VoidCallback? onTap;

  const SectionTitle(
      this.title, {
        super.key,
        this.showArrow = false,
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(S.lg, S.xl, S.lg, S.md),
      child: Row(
        children: [
          Expanded(child: Text(title, style: T.h2)),
          if (showArrow)
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.chevron_right,
                color: AppColors.textSub,
                size: 22.sp,
              ),
            ),
        ],
      ),
    );
  }
}