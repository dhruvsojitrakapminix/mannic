import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/tmdb_repository.dart';

class HomeController extends GetxController {
  final _repo = Repo.i;

  final loading = true.obs;
  final error = ''.obs;

  final hero = <Movie>[].obs;
  final trending = <Movie>[].obs;
  final boxOffice = <Movie>[].obs;
  final netflix = <Movie>[].obs;
  final prime = <Movie>[].obs;
  final disney = <Movie>[].obs;
  final apple = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    error.value = '';
    try {
      final results = await Future.wait([
        _repo.trending(),
        _repo.popularMovies(),
        _repo.topRated(),
        _repo.nowPlaying(),
        _repo.popularTv(),
        _repo.upcoming(),
      ]);

      final t = results[0];
      final pop = results[1];
      final top = results[2];
      final now = results[3];
      final tv = results[4];
      final up = results[5];

      // Hero: mix of trending and popular for variety
      final merged = <Movie>[...t, ...pop];
      final seen = <int>{};
      final heroList = <Movie>[];
      for (final m in merged) {
        if (seen.add(m.id) && heroList.length < 6) heroList.add(m);
      }

      hero.assignAll(heroList);
      trending.assignAll(t);
      boxOffice.assignAll(now.isNotEmpty ? now : top);
      netflix.assignAll(tv);
      prime.assignAll(pop);
      disney.assignAll(up);
      apple.assignAll(tv.reversed.toList());
    } catch (e) {
      error.value = 'Failed to load: $e';
      Get.snackbar(
        'Error',
        'Could not load content. Pull to refresh.',
        backgroundColor: Colors.red.withOpacity(0.85),
        colorText: Colors.white,
      );
    } finally {
      loading.value = false;
    }
  }
}