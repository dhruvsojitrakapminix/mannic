class WatchProvider {
  final int id;
  final String name;
  final String? logoPath;
  final int displayPriority;

  WatchProvider({
    required this.id,
    required this.name,
    this.logoPath,
    this.displayPriority = 0,
  });

  String get logoUrl => logoPath == null
      ? ''
      : 'https://image.tmdb.org/t/p/w92$logoPath';

  factory WatchProvider.fromJson(Map<String, dynamic> j) => WatchProvider(
    id: j['provider_id'] ?? j['id'] ?? 0,
    name: j['provider_name'] ?? j['name'] ?? '',
    logoPath: j['logo_path'],
    displayPriority: j['display_priority'] ?? 0,
  );
}

class ProvidersResponse {
  final List<WatchProvider> flatrate;
  final List<WatchProvider> rent;
  final List<WatchProvider> buy;
  final String? link;

  ProvidersResponse({
    this.flatrate = const [],
    this.rent = const [],
    this.buy = const [],
    this.link,
  });

  bool get isEmpty =>
      flatrate.isEmpty && rent.isEmpty && buy.isEmpty;

  factory ProvidersResponse.fromJson(Map<String, dynamic> j) {
    // TMDB returns a results map keyed by country; use US by default
    final results = j['results'] as Map<String, dynamic>? ?? {};
    final us = results['US'] as Map<String, dynamic>? ??
        (results.isNotEmpty
            ? results.values.first as Map<String, dynamic>
            : <String, dynamic>{});

    List<WatchProvider> parse(String key) =>
        (us[key] as List? ?? [])
            .map((e) => WatchProvider.fromJson(e))
            .toList();

    return ProvidersResponse(
      flatrate: parse('flatrate'),
      rent: parse('rent'),
      buy: parse('buy'),
      link: us['link'],
    );
  }
}