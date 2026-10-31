import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Central onboarding state — shared by all 13 onboarding screens.
///
/// Persists choices via [GetStorage] and exposes reactive fields
/// that the views bind to with `Obx` / `ObxValue`.
class OnboardingController extends GetxController {
  OnboardingController._();
  static final OnboardingController instance = OnboardingController._();

  static const _storageKey = 'onboarding_data_v1';
  final _box = GetStorage();

  // ── Text inputs ─────────────────────────────
  final name = ''.obs;
  final age = RxnInt();

  // ── Multi-select collections ────────────────
  final moods = <String>{}.obs;
  final languages = <String>{}.obs;
  final platforms = <String>{}.obs;
  final genres = <int>{}.obs;
  final watchTimes = <String>{}.obs;
  final notifTypes = <String>{}.obs;

  // ── Single-select / toggles ─────────────────
  final maturityLevel = ''.obs;           // kids | teen | adult | family
  final gridColumns = 5.obs;              // 4 | 5 | 6
  final showDock = true.obs;

  // ── Privacy toggles ─────────────────────────
  final allowAnalytics = true.obs;
  final allowPersonalization = true.obs;
  final allowRegionDetection = false.obs;

  // ── Static option catalogues ────────────────
  static const List<Map<String, String>> availableMoods = [
    {'id': 'action',    'name': 'Action',    'icon': '💥'},
    {'id': 'comedy',    'name': 'Comedy',    'icon': '😂'},
    {'id': 'drama',     'name': 'Drama',     'icon': '🎭'},
    {'id': 'horror',    'name': 'Horror',    'icon': '👻'},
    {'id': 'romance',   'name': 'Romance',   'icon': '💕'},
    {'id': 'thriller',  'name': 'Thriller',  'icon': '🔪'},
    {'id': 'scifi',     'name': 'Sci-Fi',    'icon': '🚀'},
    {'id': 'fantasy',   'name': 'Fantasy',   'icon': '🧙'},
  ];

  static const List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'zh', 'name': 'Chinese'},
  ];

  static const List<Map<String, String>> availablePlatforms = [
    {'id': 'netflix',  'name': 'Netflix',     'icon': '🎬'},
    {'id': 'prime',    'name': 'Prime Video', 'icon': '📺'},
    {'id': 'disney',   'name': 'Disney+',     'icon': '🏰'},
    {'id': 'apple',    'name': 'Apple TV+',   'icon': '🍎'},
    {'id': 'hulu',     'name': 'Hulu',        'icon': '🟢'},
    {'id': 'hbo',      'name': 'Max',         'icon': '🎥'},
    {'id': 'paramount','name': 'Paramount+',  'icon': '⛰️'},
    {'id': 'peacock',  'name': 'Peacock',     'icon': '🦚'},
  ];

  /// TMDB movie genre IDs — https://developers.themoviedb.org/3/genres
  static const List<Map<String, dynamic>> availableGenres = [
    {'id': 28,    'name': 'Action',       'icon': '💥'},
    {'id': 12,    'name': 'Adventure',    'icon': '🗺️'},
    {'id': 16,    'name': 'Animation',    'icon': '🎨'},
    {'id': 35,    'name': 'Comedy',       'icon': '😂'},
    {'id': 80,    'name': 'Crime',        'icon': '🚔'},
    {'id': 99,    'name': 'Documentary',  'icon': '📖'},
    {'id': 18,    'name': 'Drama',        'icon': '🎭'},
    {'id': 10751, 'name': 'Family',       'icon': '👨‍👩‍👧'},
    {'id': 14,    'name': 'Fantasy',      'icon': '🧙'},
    {'id': 36,    'name': 'History',      'icon': '🏛️'},
    {'id': 27,    'name': 'Horror',       'icon': '👻'},
    {'id': 10402, 'name': 'Music',        'icon': '🎵'},
    {'id': 9648,  'name': 'Mystery',      'icon': '🔍'},
    {'id': 10749, 'name': 'Romance',      'icon': '💕'},
    {'id': 878,   'name': 'Sci-Fi',       'icon': '🚀'},
    {'id': 10770, 'name': 'TV Movie',     'icon': '📺'},
    {'id': 53,    'name': 'Thriller',     'icon': '🔪'},
    {'id': 10752, 'name': 'War',          'icon': '⚔️'},
    {'id': 37,    'name': 'Western',      'icon': '🤠'},
  ];

  // ── Lifecycle ───────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _hydrate();
  }

  void _hydrate() {
    final raw = _box.read<Map>(_storageKey);
    if (raw == null) return;
    final data = Map<String, dynamic>.from(raw);

    name.value = data['name'] ?? '';
    age.value = data['age'];
    moods.assignAll(_toSet<String>(data['moods']));
    languages.assignAll(_toSet<String>(data['languages']));
    platforms.assignAll(_toSet<String>(data['platforms']));
    genres.assignAll(_toIntSet(data['genres']));
    watchTimes.assignAll(_toSet<String>(data['watchTimes']));
    notifTypes.assignAll(_toSet<String>(data['notifTypes']));
    maturityLevel.value = data['maturityLevel'] ?? '';
    gridColumns.value = data['gridColumns'] ?? 5;
    showDock.value = data['showDock'] ?? true;
    allowAnalytics.value = data['allowAnalytics'] ?? true;
    allowPersonalization.value = data['allowPersonalization'] ?? true;
    allowRegionDetection.value = data['allowRegionDetection'] ?? false;
  }

  Set<T> _toSet<T>(dynamic raw) {
    if (raw is List) return raw.whereType<T>().toSet();
    return <T>{};
  }

  Set<int> _toIntSet(dynamic raw) {
    if (raw is List) return raw.map((e) => e as int).toSet();
    return <int>{};
  }

  // ── Persist ─────────────────────────────────
  void saveAll() {
    _box.write(_storageKey, {
      'name': name.value,
      'age': age.value,
      'moods': moods.toList(),
      'languages': languages.toList(),
      'platforms': platforms.toList(),
      'genres': genres.toList(),
      'watchTimes': watchTimes.toList(),
      'notifTypes': notifTypes.toList(),
      'maturityLevel': maturityLevel.value,
      'gridColumns': gridColumns.value,
      'showDock': showDock.value,
      'allowAnalytics': allowAnalytics.value,
      'allowPersonalization': allowPersonalization.value,
      'allowRegionDetection': allowRegionDetection.value,
    });
    _box.write('onboarding_done', true);
    _box.write('user_name', name.value);
    _box.write('user_age', age.value);
  }

  // ── Reset (used from Settings → Reset onboarding) ──
  void reset() {
    _box.remove(_storageKey);
    _box.remove('onboarding_done');
    name.value = '';
    age.value = null;
    moods.clear();
    languages.clear();
    platforms.clear();
    genres.clear();
    watchTimes.clear();
    notifTypes.clear();
    maturityLevel.value = '';
    gridColumns.value = 5;
    showDock.value = true;
    allowAnalytics.value = true;
    allowPersonalization.value = true;
    allowRegionDetection.value = false;
  }

  // ── Toggle helpers ──────────────────────────
  void toggleMood(String id) {
    moods.contains(id) ? moods.remove(id) : moods.add(id);
  }

  void toggleLanguage(String code) {
    languages.contains(code)
        ? languages.remove(code)
        : languages.add(code);
  }

  void togglePlatform(String id) {
    platforms.contains(id)
        ? platforms.remove(id)
        : platforms.add(id);
  }

  void toggleGenre(int id) {
    genres.contains(id) ? genres.remove(id) : genres.add(id);
  }

  void toggleWatchTime(String id) {
    watchTimes.contains(id)
        ? watchTimes.remove(id)
        : watchTimes.add(id);
  }

  void toggleNotifType(String id) {
    notifTypes.contains(id)
        ? notifTypes.remove(id)
        : notifTypes.add(id);
  }

  // ── Summary for final screen ────────────────
  Map<String, String> summary() {
    String joinSet(Set s) => s.isEmpty ? 'Not selected' : s.join(', ');
    String genreCount() => genres.isEmpty
        ? 'Not selected'
        : '${genres.length} genres selected';

    return {
      'Name': name.value.isEmpty ? 'Not set' : name.value,
      'Age': age.value == null ? 'Not set' : '${age.value}',
      'Moods': joinSet(moods),
      'Languages': joinSet(languages),
      'Platforms': joinSet(platforms),
      'Genres': genreCount(),
      'Watch Time': joinSet(watchTimes),
      'Notifications': notifTypes.isEmpty
          ? 'Not selected'
          : '${notifTypes.length} types',
      'Content Rating':
      maturityLevel.value.isEmpty ? 'Not set' : maturityLevel.value,
      'Grid': '${gridColumns.value} columns · Dock '
          '${showDock.value ? "on" : "off"}',
    };
  }
}