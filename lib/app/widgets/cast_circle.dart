import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/cast_member.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class CastCircle extends StatelessWidget {
  final CastMember member;
  final double size;

  const CastCircle({super.key, required this.member, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w + 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox(
              width: size.w,
              height: size.w,
              child: member.profileUrl.isEmpty
                  ? Container(
                color: AppColors.card2,
                child: Icon(
                  Icons.person,
                  color: AppColors.textHint,
                  size: (size / 2).sp,
                ),
              )
                  : CachedNetworkImage(
                imageUrl: member.profileUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.card2),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.card2,
                  child: Icon(
                    Icons.person,
                    color: AppColors.textHint,
                    size: (size / 2).sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: S.sm),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: T.small.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (member.character != null)
            Text(
              member.character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: T.small.copyWith(
                color: AppColors.textHint,
                fontSize: 10.sp,
              ),
            ),
        ],
      ),
    );
  }
}