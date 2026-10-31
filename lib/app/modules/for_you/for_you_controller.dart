import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/tmdb_repository.dart';

class ForYouController extends GetxController {
  final _repo = Repo.i;

  final loading = true.obs;
  final items = <Movie>[].obs;
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      final results = await Future.wait([
        _repo.trending(),
        _repo.topRated(),
        _repo.popularMovies(),
      ]);
      final merged = <Movie>[...results[0], ...results[1], ...results[2]];
      final seen = <int>{};
      final unique = <Movie>[];
      for (final m in merged) {
        if (seen.add(m.id)) unique.add(m);
      }
      items.assignAll(unique);
    } finally {
      loading.value = false;
    }
  }

  void setIndex(int i) => currentIndex.value = i;
}