import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class RatingBadge extends StatelessWidget {
  final double vote;
  final double fontSize;
  final EdgeInsets? padding;

  const RatingBadge({
    super.key,
    required this.vote,
    this.fontSize = 11,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(R.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: Colors.white, size: fontSize.sp + 2),
          SizedBox(width: 3.w),
          Text(
            vote.toStringAsFixed(1),
            style: T.badge.copyWith(fontSize: fontSize.sp),
          ),
        ],
      ),
    );
  }
}