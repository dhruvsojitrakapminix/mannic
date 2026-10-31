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
import 'explore_controller.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ExploreController());
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(S.lg, S.lg, S.lg, S.sm),
              child: Text('Explore', style: T.h1),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(S.lg, 0, S.lg, S.md),
              child: Obx(() => Row(
                children: List.generate(
                  ExploreController.tabs.length,
                      (i) {
                    final sel = i == c.selectedTab.value;
                    return Padding(
                      padding: EdgeInsets.only(right: S.sm),
                      child: GestureDetector(
                        onTap: () => c.setTab(i),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primary
                                : AppColors.chip,
                            borderRadius:
                            BorderRadius.circular(R.pill),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.divider,
                            ),
                          ),
                          child: Text(
                            ExploreController.tabs[i],
                            style: T.chip.copyWith(
                              color: sel
                                  ? Colors.white
                                  : AppColors.textSub,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
            ),
            Expanded(
              child: Obx(() {
                if (c.loading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary),
                  );
                }
                if (c.items.isEmpty) {
                  return const EmptyState(
                    icon: Icons.explore_off_outlined,
                    title: 'Nothing here yet',
                    subtitle:
                    'Try another category or come back later.',
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: S.lg),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: S.md,
                    mainAxisSpacing: S.md,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: c.items.length,
                  itemBuilder: (_, i) {
                    final m = c.items[i];
                    return PosterCard(
                      movie: m,
                      width: 100,
                      onTap: () {
                        if (m.type == 'tv') {
                          Get.toNamed(Routes.TV_DETAIL,
                              arguments: m.id);
                        } else {
                          Get.toNamed(Routes.MOVIE_DETAIL,
                              arguments: m.id);
                        }
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}