import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/tmdb_repository.dart';

class CinemaController extends GetxController {
  final _repo = Repo.i;

  final loading = true.obs;
  final nowPlaying = <Movie>[].obs;
  final upcoming = <Movie>[].obs;
  final topRated = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      final results = await Future.wait([
        _repo.nowPlaying(),
        _repo.upcoming(),
        _repo.topRated(),
      ]);
      nowPlaying.assignAll(results[0]);
      upcoming.assignAll(results[1]);
      topRated.assignAll(results[2]);
    } finally {
      loading.value = false;
    }
  }
}