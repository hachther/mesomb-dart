import './transaction.dart';

class TransactionResponse {
  final bool success;
  late String message;
  late String? redirect;
  late Transaction transaction;
  late String reference;
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
    return success && status == 'SUCCESS';
  }
}
