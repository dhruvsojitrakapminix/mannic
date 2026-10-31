import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/tmdb_repository.dart';

class ExploreController extends GetxController {
  final _repo = Repo.i;

  static const tabs = <String>[
    'Movies',
    'TV Shows',
    'Short Drama',
  ];

  final selectedTab = 0.obs;
  final loading = true.obs;
  final items = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void setTab(int i) {
    if (i == selectedTab.value) return;
    selectedTab.value = i;
    load();
  }

  Future<void> load() async {
    loading.value = true;
    items.clear();
    try {
      if (selectedTab.value == 0) {
        items.assignAll(await _repo.popularMovies());
      } else if (selectedTab.value == 1) {
        items.assignAll(await _repo.popularTv());
      } else {
        // Short drama → use TV lists as proxy
        items.assignAll(await _repo.topRatedTv());
      }
    } finally {
      loading.value = false;
    }
  }
}