import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../view_models/movie_view_model.dart';
import '../view_models/user_view_model.dart';

class AddMoviePage extends StatefulWidget {
  const AddMoviePage({super.key});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieVM = Provider.of<MovieViewModel>(context);
    final userVM = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Movie"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Name"),
                  validator: (value) => value!.isEmpty ? "Please enter name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration("Description"),
                  validator: (value) => value!.isEmpty ? "Please enter description" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Duration (minutes)"),
                  validator: (value) => value!.isEmpty ? "Please enter duration" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _genreController,
                  decoration: _inputDecoration("Genre"),
                  validator: (value) => value!.isEmpty ? "Please enter genre" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageURLController,
                  decoration: _inputDecoration("Image URL"),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      final token = userVM.token;
                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not logged in")),
                        );
                        return;
                      }

                      final newMovie = Movie(
                        movieId: 0,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        duration: int.tryParse(_durationController.text) ?? 0,
                        genre: _genreController.text,
                        imageURL: _imageURLController.text,
                      );

                      await movieVM.addMovie(newMovie);
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      "Add Movie",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
