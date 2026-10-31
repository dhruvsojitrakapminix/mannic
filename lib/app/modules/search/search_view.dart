import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/poster_card.dart';
import 'search_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SearchPageController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(S.lg, S.lg, S.lg, S.md),
              child: Text('Search', style: T.h1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: S.lg),
              child: TextField(
                controller: c.controller,
                style: T.body.copyWith(color: AppColors.text),
                onChanged: c.onQuery,
                decoration: InputDecoration(
                  hintText: 'Search movies, shows…',
                  hintStyle: T.body.copyWith(color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                  // FIX 1: Replace Obx with ValueListenableBuilder
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: c.controller,
                    builder: (context, value, child) {
                      if (value.text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textHint),
                        onPressed: () {
                          c.controller.clear();
                          c.onQuery('');
                        },
                      );
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(R.lg),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: S.lg),
            Expanded(
              child: Obx(() {
                // Results
                if (c.controller.text.isNotEmpty) {
                  if (c.loading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }
                  if (c.results.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No results',
                      subtitle: 'Try a different keyword.',
                    );
                  }
                  // FIX 2: Pass scroll physics or use a custom ScrollView
                  return _ResultsGrid(items: c.results);
                }

                // Trending (default)
                if (c.trendingLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                return ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(S.lg, S.sm, S.lg, S.md),
                      child: Text('Trending Now', style: T.h3),
                    ),
                    _ResultsGrid(
                      items: c.trending,
                      padding: EdgeInsets.symmetric(horizontal: S.lg),
                      // FIX 3: Disable scrolling inside the GridView since the parent ListView handles it
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                    SizedBox(height: S.xl),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  final List items;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const _ResultsGrid({
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: S.md,
        mainAxisSpacing: S.md,
        childAspectRatio: 0.55,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final m = items[i];
        return PosterCard(
          movie: m,
          width: 100,
          onTap: () {
            if (m.type == 'tv') {
              Get.toNamed(Routes.TV_DETAIL, arguments: m.id);
            } else {
              Get.toNamed(Routes.MOVIE_DETAIL, arguments: m.id);
            }
          },
        );
      },
    );
  }
}