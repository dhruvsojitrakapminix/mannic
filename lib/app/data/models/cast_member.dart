class CastMember {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  final int order;

  CastMember({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
    this.order = 0,
  });

  String get profileUrl => profilePath == null
      ? ''
      : 'https://image.tmdb.org/t/p/w185$profilePath';

  factory CastMember.fromJson(Map<String, dynamic> j) => CastMember(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    character: j['character'],
    profilePath: j['profile_path'],
    order: j['order'] ?? 0,
  );
}

class CrewMember {
  final int id;
  final String name;
  final String? job;
  final String? department;
  final String? profilePath;

  CrewMember({
    required this.id,
    required this.name,
    this.job,
    this.department,
    this.profilePath,
  });

  String get profileUrl => profilePath == null
      ? ''
      : 'https://image.tmdb.org/t/p/w185$profilePath';

  factory CrewMember.fromJson(Map<String, dynamic> j) => CrewMember(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    job: j['job'],
    department: j['department'],
    profilePath: j['profile_path'],
  );
}