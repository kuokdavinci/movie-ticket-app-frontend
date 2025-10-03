import 'package:flutter/material.dart';
import 'package:movie_ticket_fe/models/movie.dart';
import 'package:movie_ticket_fe/services/movie_service.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> movies = [];
  Movie? selectedMovie;
  bool isLoading = false;

  Future<void> fetchMovies() async {
    isLoading = true;
    notifyListeners();

    try {
      movies = await _movieService.fetchMovies();
    } catch (e) {
      debugPrint("Error fetching movies: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMovieById(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      selectedMovie = await _movieService.fetchMovieById(id);
    } catch (e) {
      debugPrint("Error fetching movie: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMovie(Movie movie) async {
    try {
      final newMovie = await _movieService.addMovie(movie);
      movies.add(newMovie);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding movie: $e");
    }
  }

  Future<void> updateMovie(Movie updatedMovie) async {
    final movie = await _movieService.updateMovie(updatedMovie.movieId, updatedMovie);

    final index = movies.indexWhere((m) => m.movieId == movie.movieId);
    if (index != -1) {
      movies[index] = movie;
    }

    notifyListeners();
  }

  Future<void> deleteMovie(int id) async {
    try {
      await _movieService.deleteMovie(id);
      movies.removeWhere((m) => m.movieId == id);
      if (selectedMovie?.movieId == id) {
        selectedMovie = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting movie: $e");
    }
  }
}
