class WifiException implements Exception {
  final String message;

  WifiException(this.message);

  @override
  String toString() => 'WiFiException: $message';
}
