import './transaction.dart';

/// Transaction response object.
class TransactionResponse {
  /// Indicates if the operation was successful.
  final bool success;

  /// Message from the operation.
  late String message;

  /// Redirect URL.
  late String? redirect;

  /// Transaction object.
  late Transaction transaction;

  /// Reference of the transaction.
  late String? reference;

  /// Status of the transaction.
  late String status; // 'SUCCESS' | 'FAILED' | 'PENDING'

  TransactionResponse(Map<String, dynamic> data)
      : success = data['success'] {
    message = data['message'];
    redirect = data['redirect'];
    transaction = Transaction(data['transaction']);
    reference = data['reference'];
    status = data['status'];
  }

  bool isOperationSuccess() {
    return success;
  }

  bool isTransactionSuccess() {
    return transaction.isSuccess();
  }
}
