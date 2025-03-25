
class InvalidClientRequestException implements Exception {
  late String? code;
  late String? message;

  InvalidClientRequestException(this.message, this.code);

  @override
  String toString() {
    return 'InvalidClientRequestException: $message (code: $code)';
  }
}
