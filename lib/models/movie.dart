class Movie {
  final int movieId;
  final String name;
  final String description;
  final int duration;
  final String genre;
  final String imageURL;

  Movie({
    required this.movieId,
    required this.name,
    required this.description,
    required this.duration,
    required this.genre,
    required this.imageURL,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movieId'] ?? json['movie_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      genre: json['genre'] ?? '',
      imageURL: json['imageURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'name': name,
      'description': description,
      'duration': duration,
      'genre': genre,
      'imageURL': imageURL,
    };
  }
}
