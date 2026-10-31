class Movie {
  final int id;
  final String? title;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double vote;
  final int voteCount;
  final String? date;
  final String type; // 'movie' or 'tv'
  final List<int>? genreIds;

  Movie({
    required this.id,
    this.title,
    this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.vote = 0,
    this.voteCount = 0,
    this.date,
    this.type = 'movie',
    this.genreIds,
  });

  String get t => title ?? name ?? 'Untitled';

  String? get year {
    final d = date;
    if (d == null || d.length < 4) return null;
    return d.substring(0, 4);
  }

  String get posterUrl =>
      posterPath == null ? '' : 'https://image.tmdb.org/t/p/w500$posterPath';

  String get backdropUrl =>
      backdropPath == null ? '' : 'https://image.tmdb.org/t/p/w780$backdropPath';

  factory Movie.fromJson(Map<String, dynamic> j) => Movie(
    id: j['id'] ?? 0,
    title: j['title'],
    name: j['name'],
    overview: j['overview'],
    posterPath: j['poster_path'],
    backdropPath: j['backdrop_path'],
    vote: (j['vote_average'] ?? 0).toDouble(),
    voteCount: j['vote_count'] ?? 0,
    date: j['release_date'] ?? j['first_air_date'],
    type: j['media_type'] ?? (j['name'] != null ? 'tv' : 'movie'),
    genreIds: j['genre_ids'] != null
        ? List<int>.from(j['genre_ids'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': vote,
    'vote_count': voteCount,
    'release_date': date,
    'media_type': type,
    'genre_ids': genreIds,
  };
}