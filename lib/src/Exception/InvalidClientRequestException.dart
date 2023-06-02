

class InvalidClientRequestException implements Exception 
{
 late String? code;
  late String? message;

  InvalidClientRequestException(String? message, String? code) {
    this.message = message;
    this.code = code;
  }

  @override
  String toString() {
    return 'InvalidClientRequestException: $message (code: $code)';
  }
}