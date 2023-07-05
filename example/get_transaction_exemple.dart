import 'package:mesomb/mesomb.dart';

void main() async {
  var payment = PaymentOperation(
    '<applicationKey>',
    '<AccessKey>',
    '<SecretKey>',
  );

  var transactions = await payment.getTransactions(['ID1', 'ID2'], null);

  print(transactions);
}

