import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/favorites_repository.dart';

class FavoritesController extends GetxController {
  final favorites = FavoritesRepo.i.favorites;

  void remove(int id) => FavoritesRepo.i.remove(id);

  void clear() {
    Get.defaultDialog(
      title: 'Clear all favorites?',
      middleText: 'This cannot be undone.',
      textConfirm: 'Clear',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Get.theme.colorScheme.primary,
      onConfirm: () {
        FavoritesRepo.i.clear();
        Get.back();
      },
    );
  }

  List<Movie> get items => favorites;
}