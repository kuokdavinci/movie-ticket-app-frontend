import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _token;
  String? get token => _token;

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAdmin => _currentUser?.isAdmin ?? false;

  Future<bool> login(String username, String password) async {
    try {
      _token = await _userService.login(username, password);
      await _secureStorage.write(key: 'jwt_token', value: _token);

      await loadCurrentUser();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }
  Future<void> register(String username, String password) async {
    try {
      await _userService.register(username, password);
    } catch (e) {
      debugPrint('Register error: $e');
      throw e;
    }
  }

  Future<bool> hasToken() async {
    final stored = await _secureStorage.read(key: 'jwt_token');
    return stored != null;
  }

  Future<void> loadCurrentUser() async {
    if (_token == null) return;
    try {
      debugPrint('Fetching /me with token: $_token');
      _currentUser = await _userService.fetchCurrentUser(_token!);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load current user: $e');
    }
  }


  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    await _secureStorage.delete(key: 'jwt_token');
    notifyListeners();
  }
}
