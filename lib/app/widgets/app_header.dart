import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(S.lg, S.md, S.lg, S.md),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(R.sm),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: S.sm),
          Text('Super Tv', style: T.h2),
          const Spacer(),
          IconButton(
            onPressed: () => Get.toNamed(Routes.FAVORITES),
            icon: Icon(Icons.favorite_border,
                color: AppColors.primary, size: 22.sp),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.language,
          //       color: AppColors.primary, size: 22.sp),
          // ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: Icon(Icons.person_outline,
                color: AppColors.primary, size: 22.sp),
          ),
        ],
      ),
    );
  }
}