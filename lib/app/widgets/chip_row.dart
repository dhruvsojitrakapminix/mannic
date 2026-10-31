import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ChipRow extends StatelessWidget {
  final List<String> items;
  final int selected;
  final ValueChanged<int> onTap;

  const ChipRow({
    super.key,
    required this.items,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: S.lg),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: S.sm),
        itemBuilder: (_, i) {
          final active = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.chip,
                borderRadius: BorderRadius.circular(R.pill),
                border: Border.all(
                  color: active ? AppColors.primary : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  if (i == 0) ...[
                    Icon(
                      Icons.local_movies_outlined,
                      size: 14.sp,
                      color: AppColors.text,
                    ),
                    SizedBox(width: 6.w),
                  ],
                  Text(items[i], style: T.chip),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}