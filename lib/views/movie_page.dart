import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../view_models/movie_view_model.dart';
import '../view_models/user_view_model.dart';
import 'update_movie_page.dart';

class MoviePage extends StatelessWidget {
  final int movieId;
  const MoviePage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final movieVM = Provider.of<MovieViewModel>(context, listen: false);
    final userVM = Provider.of<UserViewModel>(context, listen: false);

    return FutureBuilder<Movie>(
      future: _fetchMovieWithToken(movieVM, userVM),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")));
        } else if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text("Movie not found")));
        }

        final movie = snapshot.data!;
        final isAdmin = userVM.isAdmin;

        return Scaffold(
          appBar: AppBar(title: Text(movie.name)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.imageURL.isNotEmpty ? movie.imageURL : "https://via.placeholder.com/200",
                    width: 180,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text("Genre: ${movie.genre}", style: const TextStyle(fontSize: 16)),
                      Text("Duration: ${movie.duration} min", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(movie.description,
                          style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 50),

                      if (isAdmin)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            UpdateMoviePage(movie: movie)),
                                  );
                                  if (result == true) {
                                    Navigator.pop(context, true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                child: const Text("Update"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                          "Are you sure you want to delete this movie?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text("Delete",
                                              style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true && userVM.token != null) {
                                    await movieVM.deleteMovie(movie.movieId, userVM.token!);
                                    Navigator.pop(context, true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                child: const Text("Delete"),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Movie> _fetchMovieWithToken(MovieViewModel movieVM, UserViewModel userVM) async {
    final token = userVM.token;
    if (token == null) throw Exception("User not logged in");
    return await movieVM.fetchMovieById(movieId, token);
  }
}
