import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../view_models/movie_view_model.dart';
import '../view_models/user_view_model.dart';
import 'add_movie_page.dart';
import 'movie_page.dart';
import 'ticket_page.dart'; // ⬅️ import thêm

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userVM = Provider.of<UserViewModel>(context, listen: false);
      final movieVM = Provider.of<MovieViewModel>(context, listen: false);

      final hasToken = await userVM.hasToken();
      if (hasToken) {
        await userVM.loadCurrentUser();
        if (userVM.token != null) {
          movieVM.setToken(userVM.token!);
          await movieVM.fetchMovies();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieVM = Provider.of<MovieViewModel>(context);
    final userVM = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          // ---------------- Taskbar ----------------
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      await movieVM.fetchMovies();
                    } catch (e) {
                      print("Fetch movies error: $e");
                    }
                  },
                  child: const Text(
                    "Movies",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                // Nút Add Movie chỉ hiện với admin
                if (userVM.currentUser?.isAdmin ?? false)
                  TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddMoviePage()),
                      );
                      if (result == true) {
                        try {
                          await movieVM.fetchMovies();
                        } catch (e) {
                          print("Fetch movies after add error: $e");
                        }
                      }
                    },
                    child: const Text(
                      "Add Movie",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                TextButton(
                  onPressed: () {
                    final userVM = Provider.of<UserViewModel>(context, listen: false);
                    if (userVM.token != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketPage(token: userVM.token!),
                        ),
                      );
                    } else {
                      // Nếu chưa login hoặc chưa có token
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng đăng nhập để xem vé')),
                      );
                    }
                  },
                  child: const Text(
                    "Tickets",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),


                // ---------------- Search box ----------------
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search by name or genre...",
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        movieVM.searchMovies(value.trim());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Movie Grid ----------------
          Expanded(
            child: movieVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : movieVM.movies.isEmpty
                ? const Center(
              child: Text(
                'No movies found',
                textAlign: TextAlign.center,
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.55,
              ),
              itemCount: movieVM.movies.length,
              itemBuilder: (context, index) {
                final Movie movie = movieVM.movies[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              MoviePage(movieId: movie.movieId)),
                    );
                    if (result == true) {
                      await movieVM.fetchMovies();
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              movie.imageURL ??
                                  "https://via.placeholder.com/150",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${movie.duration} min",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
