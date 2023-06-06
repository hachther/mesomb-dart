import 'package:PaymentMeSomb/src/Model/Transaction.dart';

class TransactionResponse {
final bool success;
late String message;
late String redirect;
late Transaction transaction;
late String reference;
late String status; // 'SUCCESS' | 'FAILED' | 'PENDING'

TransactionResponse(Map<String, dynamic> data)
: this.success = data['success'] {
this.message = data['message'];
this.redirect = data['redirect'];
this.transaction = Transaction(data['transaction']);
this.reference = data['reference'];
this.status = data['status'];
}

bool isOperationSuccess() {
return this.success;
}

bool isTransactionSuccess() {
return this.success && this.status == 'SUCCESS';
}
}
