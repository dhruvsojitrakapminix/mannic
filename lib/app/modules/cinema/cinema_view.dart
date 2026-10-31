import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/native_ad_widget.dart' show NativeAdWidget;
import '../../widgets/poster_card.dart';
import '../../widgets/section_title.dart';
import 'cinema_controller.dart';

class CinemaView extends StatelessWidget {
  const CinemaView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CinemaController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Obx(() {
          if (c.loading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: c.load,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      S.lg, S.lg, S.lg, S.md),
                  child: Text('Cinema', style: T.h1),
                ),
                const NativeAdWidget(isSmall: true),

                // Featured (now playing #1)
                if (c.nowPlaying.isNotEmpty)
                  _featured(c.nowPlaying.first),

                if (c.nowPlaying.isNotEmpty) ...[
                  const SectionTitle('Now Playing', showArrow: true),
                  _hList(c.nowPlaying),
                ],

                if (c.upcoming.isNotEmpty) ...[
                  const SectionTitle('Coming Soon', showArrow: true),
                  _hList(c.upcoming),
                ],

                if (c.topRated.isNotEmpty) ...[
                  const SectionTitle('Top Rated', showArrow: true),
                  _hList(c.topRated),
                ],

                SizedBox(height: S.xl),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _featured(Movie movie) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: S.lg),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie.id),
        child: Container(
          height: 220.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(R.lg),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(R.lg),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (movie.backdropPath != null)
                  CachedNetworkImage(
                    imageUrl: movie.backdropUrl,
                    fit: BoxFit.cover,
                  )
                else
                  Container(color: AppColors.card),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(R.sm),
                        ),
                        child: Text('IN CINEMAS',
                            style: T.badge.copyWith(fontSize: 10.sp)),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        movie.t,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: T.h2,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: AppColors.star, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            movie.vote.toStringAsFixed(1),
                            style: T.small.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (movie.year != null) ...[
                            SizedBox(width: 8.w),
                            Text('•', style: T.small),
                            SizedBox(width: 8.w),
                            Text(movie.year!, style: T.small),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hList(List<Movie> items) {
    return SizedBox(
      height: 230.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: S.lg),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: S.md),
        itemBuilder: (_, i) {
          final m = items[i];
          return PosterCard(
            movie: m,
            onTap: () => Get.toNamed(Routes.MOVIE_DETAIL, arguments: m.id),
          );
        },
      ),
    );
  }
}