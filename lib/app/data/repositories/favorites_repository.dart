import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/movie.dart';

class FavoritesRepo {
  FavoritesRepo._();
  static final FavoritesRepo i = FavoritesRepo._();

  static const _key = 'favorites_v1';
  final _box = GetStorage();

  /// Observable list of favorited movies.
  final favorites = <Movie>[].obs;

  /// Call once at app startup.
  void init() {
    final raw = _box.read<List>(_key) ?? [];
    favorites.assignAll(
      raw
          .map((e) => Movie.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(jsonEncode(e)) as Map,
        ),
      ))
          .toList(),
    );
  }

  bool isFavorite(int id) => favorites.any((m) => m.id == id);

  void toggle(Movie movie) {
    final idx = favorites.indexWhere((m) => m.id == movie.id);
    if (idx >= 0) {
      favorites.removeAt(idx);
    } else {
      favorites.insert(0, movie);
    }
    _persist();
  }

  void remove(int id) {
    favorites.removeWhere((m) => m.id == id);
    _persist();
  }

  void clear() {
    favorites.clear();
    _persist();
  }

  void _persist() {
    _box.write(
      _key,
      favorites.map((m) => m.toJson()).toList(),
    );
  }
}