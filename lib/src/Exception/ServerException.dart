class ServerException implements Exception {
  late String? code;
  late String? message;

  ServerException(this.message, this.code);

  @override
  String toString() {
    return 'ServerException : $message (code: $code)';
  }
}
