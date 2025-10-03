import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_ticket_fe/models/movie.dart';

class MovieService {
  static const String baseUrl = "http://localhost:8080/api/movies";

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<Movie> fetchMovieById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Movie.fromJson(jsonData);
    } else {
      throw Exception("Failed to load movie with id $id");
    }
  }
}
