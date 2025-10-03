import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/movie_view_model.dart';
import 'views/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Ticket',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}