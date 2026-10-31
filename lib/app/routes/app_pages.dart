import 'package:get/get.dart';

import '../modules/cinema/cinema_view.dart';
import '../modules/detail/movie_detail_view.dart';
import '../modules/detail/tv_detail_view.dart';
import '../modules/explore/explore_view.dart';
import '../modules/favorites/favorites_view.dart';
import '../modules/for_you/for_you_view.dart';
import '../modules/launcher/launcher_view.dart';
import '../modules/onboarding/onboarding_done_view.dart';
import '../modules/onboarding/onboarding_final_view.dart';
import '../modules/onboarding/onboarding_genres_view.dart';
import '../modules/onboarding/onboarding_languages_view.dart';
import '../modules/onboarding/onboarding_launcher_style_view.dart';
import '../modules/onboarding/onboarding_maturity_view.dart';
import '../modules/onboarding/onboarding_moods_view.dart';
import '../modules/onboarding/onboarding_name_age_view.dart';
import '../modules/onboarding/onboarding_notif_types_view.dart';
import '../modules/onboarding/onboarding_platforms_view.dart';
import '../modules/onboarding/onboarding_privacy_view.dart';
import '../modules/onboarding/onboarding_watch_time_view.dart';
import '../modules/profile/profile_view.dart';
import '../modules/search/results_view.dart';
import '../modules/search/search_view.dart';
import '../modules/shell/shell_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    // Entry
    GetPage(name: Routes.LAUNCHER, page: () => const LauncherView()),

    // Onboarding
    GetPage(name: Routes.OB_NAME_AGE,       page: () => const OnboardingNameAgeView()),
    GetPage(name: Routes.OB_MOODS,          page: () => const OnboardingMoodsView()),
    GetPage(name: Routes.OB_LANGUAGES,      page: () => const OnboardingLanguagesView()),
    GetPage(name: Routes.OB_PLATFORMS,      page: () => const OnboardingPlatformsView()),
    GetPage(name: Routes.OB_GENRES,         page: () => const OnboardingGenresView()),
    GetPage(name: Routes.OB_WATCH_TIME,     page: () => const OnboardingWatchTimeView()),
    GetPage(name: Routes.OB_NOTIF_TYPES,    page: () => const OnboardingNotifTypesView()),
    GetPage(name: Routes.OB_MATURITY,       page: () => const OnboardingMaturityView()),
    GetPage(name: Routes.OB_LAUNCHER_STYLE, page: () => const OnboardingLauncherStyleView()),
    GetPage(name: Routes.OB_PRIVACY,        page: () => const OnboardingPrivacyView()),
    GetPage(name: Routes.OB_FINAL,          page: () => const OnboardingFinalView()),
    GetPage(name: Routes.OB_DONE,           page: () => const OnboardingDoneView()),

    // Shell (tabs)
    GetPage(name: Routes.HOME, page: () => const ShellView()),

    // Full screens
    GetPage(name: Routes.FOR_YOU,         page: () => const ForYouView()),
    GetPage(name: Routes.EXPLORE,         page: () => const ExploreView()),
    GetPage(name: Routes.SEARCH,          page: () => const SearchView()),
    GetPage(name: Routes.CINEMA,          page: () => const CinemaView()),
    GetPage(name: Routes.PROFILE,         page: () => const ProfileView()),
    GetPage(name: Routes.FAVORITES,       page: () => const FavoritesView()),
    GetPage(name: Routes.SEARCH_RESULTS,  page: () => const SearchResultsView()),

    // Detail
    GetPage(name: Routes.MOVIE_DETAIL, page: () => const MovieDetailView()),
    GetPage(name: Routes.TV_DETAIL,    page: () => const TvDetailView()),
  ];
}