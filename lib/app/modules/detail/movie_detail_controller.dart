import 'package:get/get.dart';

import '../../data/models/cast_member.dart';
import '../../data/models/movie.dart';
import '../../data/models/provider.dart';
import '../../data/models/review.dart';
import '../../data/repositories/tmdb_repository.dart';

class MovieDetailController extends GetxController {
  final _repo = Repo.i;
  final int movieId;

  MovieDetailController(this.movieId);

  final loading = true.obs;
  final error = ''.obs;

  // Base details
  final movie = Rxn<Movie>();
  final runtime = 0.obs;
  final genres = <String>[].obs;
  final tagline = ''.obs;
  final status = ''.obs;
  final releaseDate = ''.obs;
  final budget = 0.obs;
  final revenue = 0.obs;

  // Extra
  final cast = <CastMember>[].obs;
  final crew = <CrewMember>[].obs;
  final related = <Movie>[].obs;
  final reviews = <Review>[].obs;
  final providers = Rxn<ProvidersResponse>();
  final trailerKey = RxnString();

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
        _repo.movieDetail(movieId),
        _repo.movieCreditsCast(movieId),
        _repo.movieCreditsCrew(movieId),
        _repo.movieRelated(movieId),
        _repo.movieReviews(movieId),
        _repo.movieProviders(movieId),
        _repo.movieTrailerKey(movieId),
      ]);

      final detail = results[0] as Map<String, dynamic>;
      movie.value = Movie.fromJson({
        ...detail,
        'media_type': 'movie',
      });
      runtime.value = detail['runtime'] ?? 0;
      tagline.value = detail['tagline'] ?? '';
      status.value = detail['status'] ?? '';
      releaseDate.value = detail['release_date'] ?? '';
      budget.value = detail['budget'] ?? 0;
      revenue.value = detail['revenue'] ?? 0;

      final genreList = detail['genres'] as List? ?? [];
      genres.assignAll(
        genreList.map((g) => g['name'] as String).toList(),
      );

      cast.assignAll(results[1] as List<CastMember>);
      crew.assignAll(results[2] as List<CrewMember>);
      related.assignAll(results[3] as List<Movie>);
      reviews.assignAll(results[4] as List<Review>);
      providers.value = results[5] as ProvidersResponse;
      trailerKey.value = results[6] as String?;
    } catch (e) {
      error.value = 'Failed to load details';
    } finally {
      loading.value = false;
    }
  }
}