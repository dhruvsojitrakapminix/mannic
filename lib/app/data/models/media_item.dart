/// Generic media item used by VidBox-style browse screens.
class MediaItem {
  final String id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String category;
  final double rating;
  final int year;
  final String description;

  MediaItem({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.category,
    required this.rating,
    required this.year,
    required this.description,
  });
}