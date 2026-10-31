import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/movie.dart';

/// Local-only watch history (no server sync).
class WatchHistory {
  WatchHistory._();
  static final WatchHistory instance = WatchHistory._();

  static const _key = 'watch_history_v1';
  static const _maxItems = 100;

  final _box = GetStorage();
  final items = <Movie>[].obs;

  void init() {
    final raw = _box.read<List>(_key) ?? [];
    items.assignAll(
      raw
          .map((e) => Movie.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  void record(Movie movie) {
    items.removeWhere((m) => m.id == movie.id);
    items.insert(0, movie);
    if (items.length > _maxItems) {
      items.removeRange(_maxItems, items.length);
    }
    _persist();
  }

  void clear() {
    items.clear();
    _persist();
  }

  void _persist() {
    _box.write(_key, items.map((m) => m.toJson()).toList());
  }
}