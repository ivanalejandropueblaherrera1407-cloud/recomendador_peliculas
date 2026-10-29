class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        title: (json['title'] ?? 'Sin título') as String,
        overview: (json['overview'] ?? '') as String,
        posterPath: json['poster_path'] as String?,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
        releaseDate: (json['release_date'] ?? '') as String,
      );

  String? get posterUrl =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/w500$posterPath';
}