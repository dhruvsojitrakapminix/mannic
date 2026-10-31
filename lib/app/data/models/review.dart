class Review {
  final String id;
  final String author;
  final String? avatarPath;
  final double rating;
  final String content;
  final String? createdAt;

  Review({
    required this.id,
    required this.author,
    this.avatarPath,
    this.rating = 0,
    required this.content,
    this.createdAt,
  });

  String get avatarUrl => avatarPath == null
      ? ''
      : 'https://image.tmdb.org/t/p/w185$avatarPath';

  factory Review.fromJson(Map<String, dynamic> j) {
    final details = j['author_details'] as Map<String, dynamic>? ?? {};
    return Review(
      id: j['id'] ?? '',
      author: j['author'] ?? 'Anonymous',
      avatarPath: details['avatar_path'],
      rating: (details['rating'] ?? 0).toDouble(),
      content: j['content'] ?? '',
      createdAt: j['created_at'],
    );
  }
}