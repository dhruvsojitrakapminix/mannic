import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/tmdb_repository.dart';

class SearchPageController extends GetxController {
  final _repo = Repo.i;

  final controller = TextEditingController();
  final loading = false.obs;
  final trendingLoading = true.obs;

  final results = <Movie>[].obs;
  final trending = <Movie>[].obs;

  int _reqId = 0;

  @override
  void onInit() {
    super.onInit();
    loadTrending();
  }

  Future<void> loadTrending() async {
    trendingLoading.value = true;
    try {
      trending.assignAll(await _repo.trending());
    } finally {
      trendingLoading.value = false;
    }
  }

  Future<void> onQuery(String q) async {
    final id = ++_reqId;
    if (q.trim().isEmpty) {
      results.clear();
      loading.value = false;
      return;
    }
    loading.value = true;
    try {
      final r = await _repo.search(q);
      if (id == _reqId) results.assignAll(r);
    } finally {
      if (id == _reqId) loading.value = false;
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}