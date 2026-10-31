import 'episode.dart';

class Season {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final int seasonNumber;
  final int episodeCount;
  final String? airDate;
  final List<Episode> episodes;

  Season({
    required this.id,
    required this.name,
    this.overview,
    this.posterPath,
    required this.seasonNumber,
    required this.episodeCount,
    this.airDate,
    this.episodes = const [],
  });

  String get posterUrl => posterPath == null
      ? ''
      : 'https://image.tmdb.org/t/p/w500$posterPath';

  factory Season.fromJson(Map<String, dynamic> j) => Season(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    overview: j['overview'],
    posterPath: j['poster_path'],
    seasonNumber: j['season_number'] ?? 0,
    episodeCount: j['episode_count'] ?? 0,
    airDate: j['air_date'],
    episodes: (j['episodes'] as List? ?? [])
        .map((e) => Episode.fromJson(e))
        .toList(),
  );
}