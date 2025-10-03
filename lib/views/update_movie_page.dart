import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../view_models/movie_view_model.dart';

class UpdateMoviePage extends StatefulWidget {
  final Movie movie;

  const UpdateMoviePage({super.key, required this.movie});

  @override
  State<UpdateMoviePage> createState() => _UpdateMoviePageState();
}

class _UpdateMoviePageState extends State<UpdateMoviePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late TextEditingController _genreController;
  late TextEditingController _imageURLController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.movie.name);
    _descriptionController = TextEditingController(text: widget.movie.description);
    _durationController = TextEditingController(text: widget.movie.duration.toString());
    _genreController = TextEditingController(text: widget.movie.genre);
    _imageURLController = TextEditingController(text: widget.movie.imageURL);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MovieViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Update Movie")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Name"),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration("Description"),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter description" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Duration (minutes)"),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter duration" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _genreController,
                  decoration: _inputDecoration("Genre"),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter genre" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageURLController,
                  decoration: _inputDecoration("Image URL"),
                ),
                const SizedBox(height: 20),
                _imageURLController.text.isNotEmpty
                    ? Image.network(
                  _imageURLController.text,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
                )
                    : const Text("No image selected"),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedMovie = Movie(
                          movieId: widget.movie.movieId,
                          name: _nameController.text,
                          description: _descriptionController.text,
                          duration: int.tryParse(_durationController.text) ?? 0,
                          genre: _genreController.text,
                          imageURL: _imageURLController.text,
                        );

                        await viewModel.updateMovie(updatedMovie);
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text(
                      "Update Movie",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
