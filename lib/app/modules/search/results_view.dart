import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/tmdb_repository.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/poster_card.dart';

/// Full-page results view. Can be reached directly via route.
/// Expects `arguments` to be a String query.
class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final query = (Get.arguments as String?) ?? '';
    final controller = Get.put(_ResultsController(query));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text(
          query.isEmpty ? 'Results' : 'Results for "$query"',
          style: T.h3,
        ),
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.loading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (controller.results.isEmpty) {
            return const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No results',
              subtitle: 'Try a different keyword.',
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
            itemCount: controller.results.length,
            itemBuilder: (_, i) {
              final m = controller.results[i];
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
        }),
      ),
    );
  }
}

class _ResultsController extends GetxController {
  _ResultsController(this.query);

  final String query;
  final _repo = Repo.i;

  final loading = true.obs;
  final results = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      results.assignAll(await _repo.search(query));
    } finally {
      loading.value = false;
    }
  }
}