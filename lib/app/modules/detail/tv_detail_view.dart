import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/episode.dart';
import '../../data/models/movie.dart';
import '../../data/models/season.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/cast_circle.dart';
import '../../widgets/poster_card.dart';
import '../../widgets/section_title.dart';
import 'tv_detail_controller.dart';

class TvDetailView extends StatelessWidget {
  const TvDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as int? ?? 0;
    final c = Get.put(TvDetailController(id), tag: 'tv_$id');

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() {
        if (c.loading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (c.tv.value == null) {
          return _errorView(c);
        }
        final t = c.tv.value!;

        return CustomScrollView(
          slivers: [
            _SliverHeader(tv: t),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: S.lg,
                  vertical: S.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.t, style: T.h1.copyWith(fontSize: 24.sp)),
                    SizedBox(height: S.sm),
                    if (c.tagline.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: S.sm),
                        child: Text(
                          '"${c.tagline.value}"',
                          style: T.body.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    _metaRow(c),
                    SizedBox(height: S.lg),
                    _actions(t),
                    SizedBox(height: S.xl),
                    if (t.overview?.isNotEmpty == true) ...[
                      Text('Overview', style: T.h3),
                      SizedBox(height: S.sm),
                      Text(t.overview!, style: T.body),
                      SizedBox(height: S.xl),
                    ],
                    if (c.genres.isNotEmpty) ...[
                      _chips(c.genres.toList()),
                      SizedBox(height: S.xl),
                    ],
                    if (c.providers.value?.isEmpty == false) ...[
                      Text('Watch On', style: T.h3),
                      SizedBox(height: S.md),
                      _providers(c),
                      SizedBox(height: S.xl),
                    ],
                    if (c.cast.isNotEmpty) ...[
                      Text('Cast', style: T.h3),
                      SizedBox(height: S.md),
                      _castList(c),
                      SizedBox(height: S.xl),
                    ],
                    if (c.crew.isNotEmpty) ...[
                      Text('Crew', style: T.h3),
                      SizedBox(height: S.md),
                      _crewList(c),
                      SizedBox(height: S.xl),
                    ],
                    if (c.seasons.isNotEmpty) ...[
                      Text('Seasons & Episodes', style: T.h3),
                      SizedBox(height: S.md),
                      _seasonPicker(c),
                      SizedBox(height: S.md),
                      Obx(() {
                        if (c.episodesLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }
                        if (c.episodes.isEmpty) {
                          return Text(
                            'No episodes available.',
                            style: T.body,
                          );
                        }
                        return _episodeList(c);
                      }),
                      SizedBox(height: S.xl),
                    ],
                    if (c.reviews.isNotEmpty) ...[
                      Text('Reviews', style: T.h3),
                      SizedBox(height: S.md),
                      _reviews(c),
                      SizedBox(height: S.xl),
                    ],
                  ],
                ),
              ),
            ),
            if (c.related.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle('Related', showArrow: false),
                    SizedBox(
                      height: 230.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: S.lg),
                        itemCount: c.related.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(width: S.md),
                        itemBuilder: (_, i) {
                          final r = c.related[i];
                          return PosterCard(
                            movie: r,
                            onTap: () {
                              if (r.type == 'tv') {
                                Get.toNamed(
                                  Routes.TV_DETAIL,
                                  arguments: r.id,
                                );
                              } else {
                                Get.toNamed(
                                  Routes.MOVIE_DETAIL,
                                  arguments: r.id,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: S.xxl),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  // ── Error state ────────────────────────────────
  Widget _errorView(TvDetailController c) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.textHint,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            c.error.value.isEmpty ? 'Show not found' : c.error.value,
            style: T.body,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: c.load,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ── Meta row ───────────────────────────────────
  Widget _metaRow(TvDetailController c) {
    final parts = <String>[];
    if (c.tv.value?.year != null) parts.add(c.tv.value!.year!);
    parts.add('${c.numberOfSeasons.value} Seasons');
    parts.add('${c.numberOfEpisodes.value} Eps');
    if (c.tv.value?.vote != null) {
      parts.add('★ ${c.tv.value!.vote.toStringAsFixed(1)}');
    }
    return Text(parts.join('  •  '), style: T.small);
  }

  // ── Primary actions row ────────────────────────
  Widget _actions(Movie t) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(
                  'https://www.themoviedb.org/tv/${t.id}',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
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
        SizedBox(width: S.sm),
        Obx(() {
          final isFav = FavoritesRepo.i.isFavorite(t.id);
          return _circleAction(
            icon: isFav ? Icons.favorite : Icons.favorite_border,
            tinted: isFav,
            onTap: () => FavoritesRepo.i.toggle(t),
          );
        }),
        SizedBox(width: S.sm),
        _circleAction(
          icon: Icons.share_outlined,
          onTap: () => Share.share('Check out "${t.t}" on Mannic: Movie Tv Shows!'),
        ),
      ],
    );
  }

  Widget _circleAction({
    required IconData icon,
    required VoidCallback onTap,
    bool tinted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.h,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(
          icon,
          color: tinted ? AppColors.primary : AppColors.text,
          size: 22.sp,
        ),
      ),
    );
  }

  // ── Genre chips ────────────────────────────────
  Widget _chips(List<String> items) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items
          .map(
            (g) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(R.pill),
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(
            g,
            style: T.small.copyWith(color: AppColors.text),
          ),
        ),
      )
          .toList(),
    );
  }

  // ── Watch providers ────────────────────────────
  Widget _providers(TvDetailController c) {
    final p = c.providers.value;
    if (p == null) return const SizedBox.shrink();
    final list = [...p.flatrate, ...p.rent, ...p.buy];
    return SizedBox(
      height: 72.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(width: S.md),
        itemBuilder: (_, i) {
          final prov = list[i];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 52.r,
                  height: 52.r,
                  child: prov.logoUrl.isEmpty
                      ? Container(color: AppColors.card2)
                      : CachedNetworkImage(
                    imageUrl: prov.logoUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppColors.card2),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.card2),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: 64.w,
                child: Text(
                  prov.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: T.small.copyWith(fontSize: 10.sp),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Cast row ───────────────────────────────────
  Widget _castList(TvDetailController c) {
    return SizedBox(
      height: 130.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: c.cast.length,
        separatorBuilder: (_, __) => SizedBox(width: S.md),
        itemBuilder: (_, i) => CastCircle(member: c.cast[i]),
      ),
    );
  }

  // ── Crew row ───────────────────────────────────
  Widget _crewList(TvDetailController c) {
    final keyCrew = c.crew
        .where(
          (m) => ['Director', 'Writer', 'Screenplay', 'Producer', 'Creator']
          .contains(m.job),
    )
        .take(6)
        .toList();
    if (keyCrew.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 130.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: keyCrew.length,
        separatorBuilder: (_, __) => SizedBox(width: S.md),
        itemBuilder: (_, i) {
          final member = keyCrew[i];
          return SizedBox(
            width: 80.w,
            child: Column(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 64.w,
                    height: 64.w,
                    child: member.profileUrl.isEmpty
                        ? Container(
                      color: AppColors.card2,
                      child: Icon(
                        Icons.person,
                        color: AppColors.textHint,
                      ),
                    )
                        : CachedNetworkImage(
                      imageUrl: member.profileUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.card2),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.card2),
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
                Text(
                  member.job ?? '',
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
        },
      ),
    );
  }

  // ── Season picker (horizontal) ─────────────────
  Widget _seasonPicker(TvDetailController c) {
    return SizedBox(
      height: 38.h,
      child: Obx(() {
        final sel = c.selectedSeason.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: c.seasons.length,
          separatorBuilder: (_, __) => SizedBox(width: S.sm),
          itemBuilder: (_, i) {
            final s = c.seasons[i];
            final isSel = s.seasonNumber == sel;
            return GestureDetector(
              onTap: () => c.loadEpisodes(s.seasonNumber),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primary : AppColors.chip,
                  borderRadius: BorderRadius.circular(R.pill),
                  border: Border.all(
                    color: isSel
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                ),
                child: Text(
                  s.name.isEmpty ? 'Season ${s.seasonNumber}' : s.name,
                  style: T.chip.copyWith(
                    color: isSel ? Colors.white : AppColors.textSub,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ── Episodes list ──────────────────────────────
  Widget _episodeList(TvDetailController c) {
    return Column(
      children: c.episodes.map((e) => _episodeTile(e)).toList(),
    );
  }

  Widget _episodeTile(Episode e) {
    return Container(
      margin: EdgeInsets.only(bottom: S.md),
      padding: EdgeInsets.all(S.sm),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(R.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 100.w,
              height: 60.h,
              child: e.stillUrl.isEmpty
                  ? Container(
                color: AppColors.card2,
                child: Icon(
                  Icons.movie_outlined,
                  color: AppColors.textHint,
                  size: 20.sp,
                ),
              )
                  : CachedNetworkImage(
                imageUrl: e.stillUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.card2),
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.card2),
              ),
            ),
          ),
          SizedBox(width: S.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${e.episodeNumber}. ${e.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: T.title.copyWith(fontSize: 13.sp),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    if (e.runtimeLabel.isNotEmpty) ...[
                      Text(e.runtimeLabel, style: T.small),
                      SizedBox(width: 8.w),
                    ],
                    if (e.vote > 0) ...[
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                        size: 12.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        e.vote.toStringAsFixed(1),
                        style: T.small.copyWith(color: AppColors.text),
                      ),
                    ],
                  ],
                ),
                if (e.overview != null && e.overview!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    e.overview!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: T.small.copyWith(fontSize: 11.sp),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Reviews ────────────────────────────────────
  Widget _reviews(TvDetailController c) {
    return Column(
      children: c.reviews.take(3).map((r) {
        return Container(
          margin: EdgeInsets.only(bottom: S.md),
          padding: EdgeInsets.all(S.md),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(R.md),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14.r,
                    backgroundColor: AppColors.card2,
                    backgroundImage: r.avatarUrl.isEmpty
                        ? null
                        : CachedNetworkImageProvider(r.avatarUrl),
                    child: r.avatarUrl.isEmpty
                        ? Icon(
                      Icons.person,
                      size: 14.sp,
                      color: AppColors.textHint,
                    )
                        : null,
                  ),
                  SizedBox(width: S.sm),
                  Expanded(
                    child: Text(
                      r.author,
                      style: T.title.copyWith(fontSize: 13.sp),
                    ),
                  ),
                  if (r.rating > 0)
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.star,
                          size: 12.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          r.rating.toStringAsFixed(1),
                          style: T.small.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: S.sm),
              Text(
                r.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: T.body.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Sliver header ──────────────────────────────
class _SliverHeader extends StatelessWidget {
  final Movie tv;
  const _SliverHeader({required this.tv});

  @override
  Widget build(BuildContext context) {
    final backdrop =
    tv.backdropPath != null ? tv.backdropUrl : tv.posterUrl;

    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: AppColors.bg,
      leading: IconButton(
        onPressed: Get.back,
        icon: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (backdrop.isNotEmpty)
              CachedNetworkImage(
                imageUrl: backdrop,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.card),
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.card),
              )
            else
              Container(color: AppColors.card),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.1),
                    AppColors.bg,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}