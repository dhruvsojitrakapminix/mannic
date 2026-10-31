import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/models/movie.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';
import '../../widgets/native_ad_widget.dart';
import '../../widgets/poster_card.dart';
import '../../widgets/section_title.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
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
                const AppHeader(),
                const NativeAdWidget(isSmall: false),
                if (c.hero.isNotEmpty) _HeroCarousel(items: c.hero),
                const _QuickActions(),
                if (c.trending.isNotEmpty) ...[
                  const SectionTitle('Trending Movies', showArrow: true),
                  _HList(items: c.trending),
                ],
                if (c.boxOffice.isNotEmpty) ...[
                  SectionTitle('Box Office Hits'),
                  _HList(items: c.boxOffice),
                ],
                if (c.netflix.isNotEmpty) ...[
                  SectionTitle('Netflix', showArrow: true),
                  _HList(items: c.netflix),
                ],
                if (c.prime.isNotEmpty) ...[
                  SectionTitle('Amazon Prime Video', showArrow: true),
                  _HList(items: c.prime),
                ],
                if (c.disney.isNotEmpty) ...[
                  SectionTitle('Disney+', showArrow: true),
                  _HList(items: c.disney),
                ],
                if (c.apple.isNotEmpty) ...[
                  SectionTitle('Apple TV+', showArrow: true),
                  _HList(items: c.apple),
                ],
                SizedBox(height: S.xl),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── Hero carousel ─────────────────────────────
class _HeroCarousel extends StatefulWidget {
  final List<Movie> items;
  const _HeroCarousel({required this.items});

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final _controller = CarouselSliderController();
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.items.length,
          itemBuilder: (_, i, __) => _HeroCard(movie: widget.items[i]),
          options: CarouselOptions(
            height: 480.h,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            enableInfiniteScroll: widget.items.length > 1,
            onPageChanged: (i, _) => setState(() => _i = i),
          ),
        ),
        SizedBox(height: S.md),
        SmoothPageIndicator(
          controller: PageController(initialPage: _i),
          count: widget.items.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.primary,
            dotColor: AppColors.card2,
            dotHeight: 6.h,
            dotWidth: 8.w,
            expansionFactor: 2,
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Movie movie;
  const _HeroCard({required this.movie});

  void _openDetail() {
    if (movie.type == 'tv') {
      Get.toNamed(Routes.TV_DETAIL, arguments: movie.id);
    } else {
      Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = movie.backdropPath ?? movie.posterPath;
    return GestureDetector(
      onTap: _openDetail,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(R.lg),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(R.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (path != null)
                CachedNetworkImage(
                  imageUrl: movie.backdropUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.card),
                  errorWidget: (_, __, ___) =>
                      Container(color: AppColors.card),
                )
              else
                Container(color: AppColors.card),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),

              // Top badge
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(R.sm),
                  ),
                  child: Text(
                    movie.type == 'tv' ? 'TV SHOW' : 'MOVIE',
                    style: T.badge.copyWith(fontSize: 10.sp),
                  ),
                ),
              ),

              // Bottom info
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.t,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: T.h2.copyWith(fontSize: 20.sp),
                    ),
                    SizedBox(height: 6.h),
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
                          Text(
                            movie.year!,
                            style: T.small.copyWith(color: AppColors.textSub),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _openDetail,
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Watch Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding:
                              EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(R.pill),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Quick actions ─────────────────────────────
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(S.lg, S.xl, S.lg, S.sm),
      child: Row(
        children: [
          _pill(Icons.play_arrow_rounded, 'Streaming', () {}),
          SizedBox(width: S.sm),
          _pill(Icons.movie_filter_rounded, 'Franchises', () {}),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(R.pill),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 6.w),
              Text(label, style: T.chip),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Horizontal list ───────────────────────────
class _HList extends StatelessWidget {
  final List<Movie> items;
  const _HList({required this.items});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              if (m.type == 'tv') {
                Get.toNamed(Routes.TV_DETAIL, arguments: m.id);
              } else {
                Get.toNamed(Routes.MOVIE_DETAIL, arguments: m.id);
              }
            },
          );
        },
      ),
    );
  }
}