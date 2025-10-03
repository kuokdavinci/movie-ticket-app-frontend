import 'package:flutter/material.dart';
import 'package:movie_ticket_fe/models/movie.dart';
import 'package:movie_ticket_fe/services/movie_service.dart';

class MoviePage extends StatelessWidget {
  final int movieId;

  const MoviePage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie Detail")),
      body: FutureBuilder<Movie>(
        future: MovieService().fetchMovieById(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Movie not found"));
          }

          final movie = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Genre: ${movie.genre}"),
                Text("Duration: ${movie.duration} minutes"),
                const SizedBox(height: 16),
                Text(movie.description),
              ],
            ),
          );
        },
      ),
    );
  }
}