import 'package:get/get.dart';

import '../../data/models/cast_member.dart';
import '../../data/models/episode.dart';
import '../../data/models/movie.dart';
import '../../data/models/provider.dart';
import '../../data/models/review.dart';
import '../../data/models/season.dart';
import '../../data/repositories/tmdb_repository.dart';

class TvDetailController extends GetxController {
  final _repo = Repo.i;
  final int tvId;

  TvDetailController(this.tvId);

  final loading = true.obs;
  final error = ''.obs;

  final tv = Rxn<Movie>();
  final genres = <String>[].obs;
  final tagline = ''.obs;
  final status = ''.obs;
  final firstAirDate = ''.obs;
  final lastAirDate = ''.obs;
  final numberOfSeasons = 0.obs;
  final numberOfEpisodes = 0.obs;
  final seasons = <Season>[].obs;
  final selectedSeason = 0.obs; // season_number

  final cast = <CastMember>[].obs;
  final crew = <CrewMember>[].obs;
  final related = <Movie>[].obs;
  final reviews = <Review>[].obs;
  final providers = Rxn<ProvidersResponse>();
  final trailerKey = RxnString();

  final episodesLoading = false.obs;
  final episodes = <Episode>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    error.value = '';
    try {
      final results = await Future.wait([
        _repo.tvDetail(tvId),
        _repo.tvCreditsCast(tvId),
        _repo.tvCreditsCrew(tvId),
        _repo.tvRelated(tvId),
        _repo.tvReviews(tvId),
        _repo.tvProviders(tvId),
        _repo.tvTrailerKey(tvId),
      ]);

      final detail = results[0] as Map<String, dynamic>;
      tv.value = Movie.fromJson({...detail, 'media_type': 'tv'});
      tagline.value = detail['tagline'] ?? '';
      status.value = detail['status'] ?? '';
      firstAirDate.value = detail['first_air_date'] ?? '';
      lastAirDate.value = detail['last_air_date'] ?? '';
      numberOfSeasons.value = detail['number_of_seasons'] ?? 0;
      numberOfEpisodes.value = detail['number_of_episodes'] ?? 0;

      final genreList = detail['genres'] as List? ?? [];
      genres.assignAll(genreList.map((g) => g['name'] as String).toList());

      final seasonList = detail['seasons'] as List? ?? [];
      seasons.assignAll(seasonList.map((s) => Season.fromJson(s)).toList());

      cast.assignAll(results[1] as List<CastMember>);
      crew.assignAll(results[2] as List<CrewMember>);
      related.assignAll(results[3] as List<Movie>);
      reviews.assignAll(results[4] as List<Review>);
      providers.value = results[5] as ProvidersResponse;
      trailerKey.value = results[6] as String?;

      // Auto-load first season's episodes
      if (seasons.isNotEmpty) {
        selectedSeason.value = seasons.first.seasonNumber;
        loadEpisodes(seasons.first.seasonNumber);
      }
    } catch (e) {
      error.value = 'Failed to load TV details';
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadEpisodes(int seasonNumber) async {
    selectedSeason.value = seasonNumber;
    episodesLoading.value = true;
    episodes.clear();
    try {
      final s = await _repo.seasonDetails(tvId, seasonNumber);
      episodes.assignAll(s.episodes);
    } finally {
      episodesLoading.value = false;
    }
  }
}