

class ServerException implements Exception{
  late String? code;
  late String? message;

  ServerException (String message, String? code) {
    this.message = message;
    this.code = code;
  }

  @override
  String toString() {
    return 'ServerException : $message (code: $code)';
  }
}