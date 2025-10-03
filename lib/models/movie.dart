class Movie {
  final int movieId;
  final String name;
  final String description;
  final int duration;
  final String genre;

  Movie({
    required this.movieId,
    required this.name,
    required this.description,
    required this.duration,
    required this.genre,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movie_id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      genre: json['genre'],
    );
  }
}