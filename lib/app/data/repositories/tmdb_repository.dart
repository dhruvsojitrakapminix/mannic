import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/cast_member.dart';
import '../models/movie.dart';
import '../models/provider.dart';
import '../models/review.dart';
import '../models/season.dart';

class Repo {
  Repo._();
  static final Repo i = Repo._();

  final _api = ApiClient.i;

  // ── Helpers ─────────────────────────────────
  Future<List<Movie>> _list(String path, [Map<String, dynamic>? q]) async {
    final r = await _api.get(path, query: q);
    final data = r.data['results'] as List? ?? [];
    return data.map((e) => Movie.fromJson(e)).toList();
  }

  List<Movie> _parseList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((e) => Movie.fromJson(e)).toList();
  }

  // ── Lists ───────────────────────────────────
  Future<List<Movie>> trending()       => _list(Api.trending);
  Future<List<Movie>> trendingWeek()   => _list(Api.trendingWeek);
  Future<List<Movie>> popularMovies()  => _list(Api.popularMovies);
  Future<List<Movie>> topRated()       => _list(Api.topRated);
  Future<List<Movie>> nowPlaying()     => _list(Api.nowPlaying);
  Future<List<Movie>> upcoming()       => _list(Api.upcoming);
  Future<List<Movie>> popularTv()      => _list(Api.popularTv);
  Future<List<Movie>> topRatedTv()     => _list(Api.topRatedTv);
  Future<List<Movie>> airingTodayTv()  => _list(Api.airingTodayTv);

  // ── Search ──────────────────────────────────
  Future<List<Movie>> search(String q) {
    if (q.trim().isEmpty) return Future.value([]);
    return _list(Api.searchMulti, {'query': q});
  }

  // ── Discover (filter) ───────────────────────
  Future<List<Movie>> discoverMovie({
    int? genreId,
    int? year,
    String sortBy = 'popularity.desc',
    int page = 1,
  }) =>
      _list(Api.discoverMovie, {
        if (genreId != null) 'with_genres': genreId,
        if (year != null) 'primary_release_year': year,
        'sort_by': sortBy,
        'page': page,
      });

  Future<List<Movie>> discoverTv({
    int? genreId,
    int? year,
    String sortBy = 'popularity.desc',
    int page = 1,
  }) =>
      _list(Api.discoverTv, {
        if (genreId != null) 'with_genres': genreId,
        if (year != null) 'first_air_date_year': year,
        'sort_by': sortBy,
        'page': page,
      });

  // ── Movie details ───────────────────────────
  Future<Map<String, dynamic>> movieDetail(int id) async =>
      (await _api.get(Api.movie(id))).data;

  Future<List<CastMember>> movieCreditsCast(int id) async {
    final data = (await _api.get(Api.movieCredits(id))).data;
    return (data['cast'] as List? ?? [])
        .map((e) => CastMember.fromJson(e))
        .toList();
  }

  Future<List<CrewMember>> movieCreditsCrew(int id) async {
    final data = (await _api.get(Api.movieCredits(id))).data;
    return (data['crew'] as List? ?? [])
        .map((e) => CrewMember.fromJson(e))
        .toList();
  }

  Future<List<Movie>> movieRelated(int id) => _list(Api.movieRelated(id));

  Future<List<Review>> movieReviews(int id) async {
    final data = (await _api.get(Api.movieReviews(id))).data;
    return (data['results'] as List? ?? [])
        .map((e) => Review.fromJson(e))
        .toList();
  }

  Future<ProvidersResponse> movieProviders(int id) async {
    final data = (await _api.get(Api.movieProviders(id))).data;
    return ProvidersResponse.fromJson(data);
  }

  Future<String?> movieTrailerKey(int id) async {
    final data = (await _api.get(Api.movieVideos(id))).data;
    final results = data['results'] as List? ?? [];
    for (final v in results) {
      if (v['site'] == 'YouTube' && v['type'] == 'Trailer') {
        return v['key'] as String?;
      }
    }
    return null;
  }

  // ── TV details ──────────────────────────────
  Future<Map<String, dynamic>> tvDetail(int id) async =>
      (await _api.get(Api.tv(id))).data;

  Future<List<CastMember>> tvCreditsCast(int id) async {
    final data = (await _api.get(Api.tvCredits(id))).data;
    return (data['cast'] as List? ?? [])
        .map((e) => CastMember.fromJson(e))
        .toList();
  }

  Future<List<CrewMember>> tvCreditsCrew(int id) async {
    final data = (await _api.get(Api.tvCredits(id))).data;
    return (data['crew'] as List? ?? [])
        .map((e) => CrewMember.fromJson(e))
        .toList();
  }

  Future<List<Movie>> tvRelated(int id) => _list(Api.tvRelated(id));

  Future<List<Review>> tvReviews(int id) async {
    final data = (await _api.get(Api.tvReviews(id))).data;
    return (data['results'] as List? ?? [])
        .map((e) => Review.fromJson(e))
        .toList();
  }

  Future<ProvidersResponse> tvProviders(int id) async {
    final data = (await _api.get(Api.tvProviders(id))).data;
    return ProvidersResponse.fromJson(data);
  }

  Future<String?> tvTrailerKey(int id) async {
    final data = (await _api.get(Api.tvVideos(id))).data;
    final results = data['results'] as List? ?? [];
    for (final v in results) {
      if (v['site'] == 'YouTube' && v['type'] == 'Trailer') {
        return v['key'] as String?;
      }
    }
    return null;
  }

  Future<Season> seasonDetails(int id, int seasonNumber) async {
    final data = (await _api.get(Api.season(id, seasonNumber))).data;
    return Season.fromJson(data);
  }

  // ── Genres ──────────────────────────────────
  Future<Map<int, String>> movieGenres() async {
    final data = (await _api.get(Api.genresMovie)).data;
    final list = data['genres'] as List? ?? [];
    return {for (final g in list) g['id'] as int: g['name'] as String};
  }

  Future<Map<int, String>> tvGenres() async {
    final data = (await _api.get(Api.genresTv)).data;
    final list = data['genres'] as List? ?? [];
    return {for (final g in list) g['id'] as int: g['name'] as String};
  }
}