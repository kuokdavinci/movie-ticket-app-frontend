class ApiConfig {
  const ApiConfig._();

  // Override at runtime:
  // flutter run --dart-define=API_BASE_URL=http://localhost:8090/api
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8090/api',
  );
}
