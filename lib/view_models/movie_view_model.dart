import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieService _movieService = MovieService();
  String? _token;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<void> fetchMovies() async {
    if (_token == null) throw Exception("No token set");
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await _movieService.fetchMovies(_token!);
    } catch (e) {
      print("Error fetching movies: $e");
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    if (_token == null) throw Exception("No token set");
    _isLoading = true;
    notifyListeners();
    try {
      if (query.isEmpty) {
        await fetchMovies();
        return;
      }
      _movies = await _movieService.searchMovies(query, _token!);
    } catch (e) {
      print("Error searching movies: $e");
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Movie> fetchMovieById(int movieId, String token) async {
    if (_token == null) throw Exception("No token set");
    return await _movieService.fetchMovieById(movieId, _token!);
  }

  Future<void> addMovie(Movie newMovie) async {
    if (_token == null) throw Exception("No token set");
    final movieFromServer = await _movieService.addMovie(newMovie, _token!);
    _movies.insert(0, movieFromServer);
    notifyListeners();
  }

  Future<void> updateMovie(Movie movieToUpdate) async {
    if (_token == null) throw Exception("No token set");
    final updatedMovie = await _movieService.updateMovie(
        movieToUpdate.movieId, movieToUpdate, _token!);
    final index = _movies.indexWhere((m) => m.movieId == updatedMovie.movieId);
    if (index != -1) {
      _movies[index] = updatedMovie;
      notifyListeners();
    }
  }

  Future<void> deleteMovie(int movieId, String s) async {
    if (_token == null) throw Exception("No token set");
    await _movieService.deleteMovie(movieId, _token!);
    _movies.removeWhere((m) => m.movieId == movieId);
    notifyListeners();
  }
}
