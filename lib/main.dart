import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/movie_view_model.dart';
import 'view_models/user_view_model.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => MovieViewModel()),
      ],
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
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _isAuth;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final userVM = Provider.of<UserViewModel>(context, listen: false);
    final hasToken = await userVM.hasToken();

    if (hasToken) {
      try {
        await userVM.loadCurrentUser();
      } catch (e) {}
    }

    if (!mounted) return;
    setState(() {
      _isAuth = hasToken;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isAuth == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (_isAuth == true) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
