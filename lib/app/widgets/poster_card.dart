import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/movie.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class PosterCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final bool showRating;
  final bool showTitle;
  final VoidCallback? onTap;

  const PosterCard({
    super.key,
    required this.movie,
    this.width = 120,
    this.showRating = true,
    this.showTitle = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(R.md),
                  child: AspectRatio(
                    aspectRatio: 2.3 / 3,
                    child: movie.posterPath == null
                        ? Container(color: AppColors.card2)
                        : CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.card2),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.card2,
                        child: const Icon(
                          Icons.broken_image,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ),
                if (showRating)
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(R.sm),
                      ),
                      child: Text(
                        movie.vote.toStringAsFixed(1),
                        style: T.badge,
                      ),
                    ),
                  ),
              ],
            ),
            if (showTitle) ...[
              SizedBox(height: 6.h),
              Text(
                movie.t,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: T.title,
              ),
            ],
          ],
        ),
      ),
    );
  }
}