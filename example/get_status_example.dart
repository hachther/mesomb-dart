import 'package:mesomb/mesomb.dart';

void main() async {
  var payment = PaymentOperation(
    '<applicationKey>',
    '<AccessKey>',
    '<SecretKey>',
  );
  final application = await payment.getStatus(DateTime.now());
  print(application);
}