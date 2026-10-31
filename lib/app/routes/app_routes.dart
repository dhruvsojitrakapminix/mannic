class Routes {
  Routes._();

  // ── Entry ───────────────────────────────────
  static const LAUNCHER = '/launcher';

  // ── Onboarding ──────────────────────────────
  static const OB_NAME_AGE       = '/onboarding/name-age';
  static const OB_MOODS          = '/onboarding/moods';
  static const OB_LANGUAGES      = '/onboarding/languages';
  static const OB_PLATFORMS      = '/onboarding/platforms';
  static const OB_GENRES         = '/onboarding/genres';
  static const OB_WATCH_TIME     = '/onboarding/watch-time';
  static const OB_NOTIF_TYPES    = '/onboarding/notif-types';
  static const OB_MATURITY       = '/onboarding/maturity';
  static const OB_LAUNCHER_STYLE = '/onboarding/launcher-style';
  static const OB_PRIVACY        = '/onboarding/privacy';
  static const OB_FINAL          = '/onboarding/final';
  static const OB_DONE           = '/onboarding/done';

  // ── Shell (main tabs) ───────────────────────
  static const HOME    = '/';
  static const FOR_YOU = '/for-you';
  static const EXPLORE = '/explore';
  static const SEARCH  = '/search';
  static const CINEMA  = '/cinema';

  // ── Full screens ────────────────────────────
  static const PROFILE        = '/profile';
  static const FAVORITES      = '/favorites';
  static const SEARCH_RESULTS = '/search-results';

  // ── Detail (params: id) ─────────────────────
  static const MOVIE_DETAIL = '/detail/movie';
  static const TV_DETAIL    = '/detail/tv';
}