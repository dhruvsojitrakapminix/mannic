import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/poster_card.dart';
import 'favorites_controller.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text('My Favorites', style: T.h3),
        iconTheme: const IconThemeData(color: AppColors.text),
        actions: [
          Obx(() {
            if (c.items.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: c.clear,
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (c.items.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: 'No favorites yet',
              subtitle:
              'Tap the heart on any movie or show to save it here.',
              action: ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.HOME),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, vertical: 12.h),
                ),
                child: const Text('Browse'),
              ),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.all(S.lg),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: S.md,
              mainAxisSpacing: S.md,
              childAspectRatio: 0.55,
            ),
            itemCount: c.items.length,
            itemBuilder: (_, i) {
              final m = c.items[i];
              return GestureDetector(
                onLongPress: () => c.remove(m.id),
                child: PosterCard(
                  movie: m,
                  width: 100,
                  onTap: () {
                    if (m.type == 'tv') {
                      Get.toNamed(Routes.TV_DETAIL, arguments: m.id);
                    } else {
                      Get.toNamed(Routes.MOVIE_DETAIL, arguments: m.id);
                    }
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}