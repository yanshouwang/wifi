class WiFiException implements Exception {
  final String message;

  WiFiException(this.message);

  @override
  String toString() => 'WiFiException: $message';
}
