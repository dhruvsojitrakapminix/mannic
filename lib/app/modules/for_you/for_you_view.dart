import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'for_you_controller.dart';

class ForYouView extends StatelessWidget {
  const ForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ForYouController());
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Obx(() {
          if (c.loading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (c.items.isEmpty) {
            return Center(
              child: Text('Nothing to show yet', style: T.body),
            );
          }
          return CarouselSlider.builder(
            itemCount: c.items.length,
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (i, _) => c.setIndex(i),
            ),
            itemBuilder: (_, i, __) => _ForYouCard(movie: c.items[i]),
          );
        }),
      ),
    );
  }
}

class _ForYouCard extends StatelessWidget {
  final Movie movie;
  const _ForYouCard({required this.movie});

  void _openDetail() {
    if (movie.type == 'tv') {
      Get.toNamed(Routes.TV_DETAIL, arguments: movie.id);
    } else {
      Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backdrop =
    movie.backdropPath != null ? movie.backdropUrl : movie.posterUrl;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        if (backdrop.isNotEmpty)
          CachedNetworkImage(
            imageUrl: backdrop,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.card),
            errorWidget: (_, __, ___) => Container(color: AppColors.card),
          )
        else
          Container(color: AppColors.card),

        // Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.15),
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.95),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Content
        Positioned(
          left: 24.w,
          right: 24.w,
          bottom: 24.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Type badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(R.sm),
                ),
                child: Text(
                  movie.type == 'tv' ? 'TV SHOW' : 'MOVIE',
                  style: T.badge.copyWith(fontSize: 10.sp),
                ),
              ),
              SizedBox(height: S.md),

              // Title
              Text(
                movie.t,
                style: T.h1.copyWith(fontSize: 30.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: S.sm),

              // Meta
              Row(
                children: [
                  Icon(Icons.star_rounded,
                      color: AppColors.star, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    movie.vote.toStringAsFixed(1),
                    style: T.small.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (movie.year != null) ...[
                    SizedBox(width: 10.w),
                    Text('•', style: T.small),
                    SizedBox(width: 10.w),
                    Text(movie.year!,
                        style: T.small.copyWith(color: AppColors.textSub)),
                  ],
                ],
              ),
              SizedBox(height: S.md),

              // Overview
              if (movie.overview != null && movie.overview!.isNotEmpty)
                Text(
                  movie.overview!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: T.body,
                ),
              SizedBox(height: S.lg),

              // Primary action
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: _openDetail,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Watch Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(R.pill),
                    ),
                  ),
                ),
              ),
              SizedBox(height: S.md),

              // Action row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _action(
                    icon: Icons.info_outline,
                    label: 'Info',
                    onTap: _openDetail,
                  ),
                  Obx(() {
                    final isFav =
                    FavoritesRepo.i.isFavorite(movie.id);
                    return _action(
                      icon: isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: isFav ? 'Saved' : 'Save',
                      tinted: isFav,
                      onTap: () => FavoritesRepo.i.toggle(movie),
                    );
                  }),
                  _action(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {
                      Share.share(
                        'Check out "${movie.t}" on BitTV!',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _action({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool tinted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: tinted ? AppColors.primary : Colors.white,
              size: 26.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: T.small.copyWith(
                color: tinted ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}