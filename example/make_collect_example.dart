import 'package:mesomb/mesomb.dart';
// Collect money from an account
void main() async {
 final payment = PaymentOperation(
  '<applicationKey>',
  '<AccessKey>',
  '<SecretKey>',
 );
 final response = await payment.makeCollect({
   'amount': 100,
   'service': 'MTN',
   'payer': '677550203',
   'nonce': RandomGenerator.nonce(),
 });
 print(response.isOperationSuccess());
 print(response.isTransactionSuccess());
}
