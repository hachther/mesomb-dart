import 'package:mesomb/src/Operation/Signature.dart';
import 'package:test/test.dart';

void main() {
  test('Should compute signature', () {
    expect(
        Signature.signRequest(
            'payment',
            'GET',
            'http://127.0.0.1:8000/en/api/v1.1/payment/collect/',
            DateTime.utc(2023, 01, 16),
            'fihser', {
          'accessKey': 'c6c40b76-8119-4e93-81bf-bfb55417b392',
          'secretKey': 'fe8c2445-810f-4caa-95c9-778d51580163'
        }),
        'HMAC-SHA1 Credential=c6c40b76-8119-4e93-81bf-bfb55417b392/20230116/payment/mesomb_request, SignedHeaders=host;x-mesomb-date;x-mesomb-nonce, Signature=92866ff78427c739c1d48c9223a6133cde46ab5d');
  });
}
