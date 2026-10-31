class Episode {
  final int id;
  final String name;
  final String? overview;
  final String? stillPath;
  final int episodeNumber;
  final int seasonNumber;
  final int? runtime;
  final String? airDate;
  final double vote;

  Episode({
    required this.id,
    required this.name,
    this.overview,
    this.stillPath,
    required this.episodeNumber,
    required this.seasonNumber,
    this.runtime,
    this.airDate,
    this.vote = 0,
  });

  String get stillUrl => stillPath == null
      ? ''
      : 'https://image.tmdb.org/t/p/w500$stillPath';

  String get runtimeLabel {
    final r = runtime;
    if (r == null || r == 0) return '';
    return '${r}m';
  }

  factory Episode.fromJson(Map<String, dynamic> j) => Episode(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    overview: j['overview'],
    stillPath: j['still_path'],
    episodeNumber: j['episode_number'] ?? 0,
    seasonNumber: j['season_number'] ?? 0,
    runtime: j['runtime'],
    airDate: j['air_date'],
    vote: (j['vote_average'] ?? 0).toDouble(),
  );
}