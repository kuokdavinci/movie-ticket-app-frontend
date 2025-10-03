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
      movieId: json['movie_id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      genre: json['genre'],
      imageURL: json['imageURL'] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'genre': genre,
      'duration': duration,
      'description': description,
      'imageURL': imageURL,
    };

    return json;
  }
}