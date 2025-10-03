import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_ticket_fe/models/movie.dart';

class MovieService {
  static const String baseUrl = "http://localhost:8080/api";

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse("$baseUrl/movies"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<Movie> fetchMovieById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/movies/$id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Movie.fromJson(jsonData);
    } else {
      throw Exception("Failed to load movie with id $id");
    }
  }

  Future<Movie> addMovie(Movie movie) async {
    final response = await http.post(
      Uri.parse("$baseUrl/movies"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(movie.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Movie.fromJson(jsonData);
    } else {
      throw Exception("Failed to add movie: ${response.body}");
    }
  }

  Future<Movie> updateMovie(int id, Movie movie) async {
    final response = await http.put(
      Uri.parse("$baseUrl/movies/$id"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(movie.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Movie.fromJson(jsonData);
    } else {
      throw Exception("Failed to update movie: ${response.body}");
    }
  }

  Future<void> deleteMovie(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/movies/$id"));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete movie: ${response.body}");
    }
  }
}
