class User {
  final int userId;
  final String username;
  final String role;

  User({required this.userId, required this.username, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      role: json['role'] ?? 'ROLE_USER',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'role': role,
    };
  }

  bool get isAdmin => role.toUpperCase() == "ROLE_ADMIN";
}