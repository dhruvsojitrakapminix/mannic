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
              scrollDirection: Axis.vertical,
              autoPlay: true,
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (i, _) => c.setIndex(i),
            ),
            itemBuilder: (_, i, __) => _ForYouCard(movie: c.items[i], iCurrentCount: i+1, iTotalCount: c.items.length,),
          );
        }),
      ),
    );
  }
}

class _ForYouCard extends StatelessWidget {
  final Movie movie;
  final int iTotalCount;
  final int iCurrentCount;
  const _ForYouCard({required this.movie, required this.iTotalCount, required this.iCurrentCount});

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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
                  Icon(Icons.star_rounded, color: AppColors.star, size: 16.sp),
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

              // ── Bottom Row: Watch Now and Info ──
              Row(
                children: [
                  // Watch Now Button (Expanded to take available space)
                  Expanded(
                    flex: 3,
                    child: SizedBox(
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
                  ),
                  SizedBox(width: 12.w),
                  // Info Button (Square/Circular shape)
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _openDetail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(R.pill),
                          ),
                        ),
                        child: const Icon(Icons.info_outline),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          left: 24.w,
          right: 24.w,
          top: 24.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Side: Counter (Example: 10/list.length)
              // Replace `10` with your actual current index variable (e.g., `currentIndex + 1`)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent background
                  borderRadius: BorderRadius.circular(R.sm), // Rounded borders
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2), // Subtle border for depth
                    width: 1,
                  ),
                ),
                child: Text(
                  "$iCurrentCount/$iTotalCount",
                  style: T.title.copyWith(
                    color: AppColors.textSub,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),

              // Right Side: Save and Share
              Row(
                children: [
                  Obx(() {
                    final isFav = FavoritesRepo.i.isFavorite(movie.id);
                    return IconButton(
                      onPressed: () => FavoritesRepo.i.toggle(movie),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.primary : Colors.white,
                        size: 35,
                      ),
                    );
                  }),
                  IconButton(
                    onPressed: () {
                      Share.share(
                        'Check out "${movie.t}" on Super Tv!',
                      );
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
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