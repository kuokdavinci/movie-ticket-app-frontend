import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../view_models/movie_view_model.dart';
import '../view_models/user_view_model.dart';

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

  bool _isLoading = false;
  String _previewImageUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.movie.name);
    _descriptionController = TextEditingController(text: widget.movie.description);
    _durationController = TextEditingController(text: widget.movie.duration.toString());
    _genreController = TextEditingController(text: widget.movie.genre);
    _imageURLController = TextEditingController(text: widget.movie.imageURL);

    _previewImageUrl = widget.movie.imageURL ?? '';

    _imageURLController.addListener(() {
      if (_imageURLController.text != _previewImageUrl) {
        setState(() {
          _previewImageUrl = _imageURLController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _genreController.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Future<void> _onUpdateMovie() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedMovie = Movie(
      movieId: widget.movie.movieId,
      name: _nameController.text,
      description: _descriptionController.text,
      duration: int.tryParse(_durationController.text) ?? 0,
      genre: _genreController.text,
      imageURL: _imageURLController.text,
    );

    final viewModel = Provider.of<MovieViewModel>(context, listen: false);
    final userVM = Provider.of<UserViewModel>(context, listen: false);
    final token = userVM.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in"), backgroundColor: Colors.red),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      await viewModel.updateMovie(updatedMovie) ;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movie updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update movie: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  validator: (value) => value!.isEmpty ? "Please enter name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration("Description"),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? "Please enter description" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Duration (minutes)"),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter duration";
                    if (int.tryParse(value) == null) return "Please enter a valid number";
                    return null;
                  },
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
                _previewImageUrl.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    _previewImageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    ),
                  ),
                )
                    : Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(child: Text("No image URL provided")),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isLoading ? null : _onUpdateMovie,
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                        : const Text(
                      "Update Movie",
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
