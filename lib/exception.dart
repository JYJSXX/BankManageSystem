class serverException implements Exception {
  final String message;
  serverException(this.message);
  @override
  String toString() {
    return message;
  }
}