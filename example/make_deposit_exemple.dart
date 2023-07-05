import 'package:mesomb/mesomb.dart';
void main() async {
  var payment = PaymentOperation(
    '<applicationKey>',
    '<AccessKey>',
    '<SecretKey>',
  );
  final response = await payment.makeDeposit({
    'amount': 100,
    'service': 'MTN',
    'receiver': '677550203',
    'nonce': RandomGenerator.nonce(),
  });
  print(response.isOperationSuccess());
  print(response.isTransactionSuccess());
}