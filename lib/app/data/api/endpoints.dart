import '../services/app_config.dart';

class Api {
  Api._();

  // ── Base URL / image base — from config, with fallbacks ──
  static String get base {
    final b = AppConfigStore.instance.appConfig.apiData.base;
    return b.isNotEmpty ? b : 'https://api.themoviedb.org/3';
  }

  static String get img {
    final v = AppConfigStore.instance.appConfig.apiData.img;
    return v.isNotEmpty ? v : 'https://image.tmdb.org/t/p/w500';
  }

  static String get imgBig {
    final v = AppConfigStore.instance.appConfig.apiData.imgBig;
    return v.isNotEmpty ? v : 'https://image.tmdb.org/t/p/w780';
  }

  static const String imgOrig = 'https://image.tmdb.org/t/p/original';
  static const String imgProfile = 'https://image.tmdb.org/t/p/w185';

  // ── TMDB API key / bearer token ──────────────────────
  /// Reads bearer token from config. If empty, falls back to the
  /// `key` const below (for `api_key=` query-param mode).
  static String get token {
    final t = AppConfigStore.instance.appConfig.apiData.token;
    return t.isNotEmpty ? t : '';
  }

  // Legacy: if you ever use `?api_key=` instead of bearer auth
  static const String key = '';

  // ── Lists ────────────────────────────────────────────
  static const String trending      = '/trending/all/day';
  static const String trendingWeek  = '/trending/all/week';
  static const String popularMovies = '/movie/popular';
  static const String topRated      = '/movie/top_rated';
  static const String nowPlaying    = '/movie/now_playing';
  static const String upcoming      = '/movie/upcoming';
  static const String popularTv     = '/tv/popular';
  static const String topRatedTv    = '/tv/top_rated';
  static const String airingTodayTv = '/tv/airing_today';
  static const String searchMulti   = '/search/multi';
  static const String genresMovie   = '/genre/movie/list';
  static const String genresTv      = '/genre/tv/list';

  // ── Movie ────────────────────────────────────────────
  static String movie(int id)           => '/movie/$id';
  static String movieCredits(int id)    => '/movie/$id/credits';
  static String movieRelated(int id)    => '/movie/$id/recommendations';
  static String movieSimilar(int id)    => '/movie/$id/similar';
  static String movieReviews(int id)    => '/movie/$id/reviews';
  static String movieProviders(int id)  => '/movie/$id/watch/providers';
  static String movieVideos(int id)     => '/movie/$id/videos';

  // ── TV ───────────────────────────────────────────────
  static String tv(int id)              => '/tv/$id';
  static String tvCredits(int id)       => '/tv/$id/credits';
  static String tvRelated(int id)       => '/tv/$id/recommendations';
  static String tvSimilar(int id)       => '/tv/$id/similar';
  static String tvReviews(int id)       => '/tv/$id/reviews';
  static String tvProviders(int id)     => '/tv/$id/watch/providers';
  static String tvVideos(int id)        => '/tv/$id/videos';
  static String season(int id, int s)   => '/tv/$id/season/$s';
  static String episode(int id, int s, int e) =>
      '/tv/$id/season/$s/episode/$e';

  // ── Discover ─────────────────────────────────────────
  static const String discoverMovie = '/discover/movie';
  static const String discoverTv    = '/discover/tv';
}