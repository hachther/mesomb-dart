import 'package:mesomb/mesomb.dart';
import 'package:mesomb/src/exceptions/invalid_client_request_exception.dart';
import 'package:mesomb/src/exceptions/permission_denied_exception.dart';
import 'package:mesomb/src/exceptions/service_not_found_exception.dart';
import 'package:mesomb/src/mesomb.dart';
import 'package:test/test.dart';

String applicationKey = '2bb525516ff374bb52545bf22ae4da7d655ba9fd';
String accessKey = 'c6c40b76-8119-4e93-81bf-bfb55417b392';
String secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';

void main() {
  group('PaymentOperation', () {
    // var applicationKey = '2bb525516ff374bb52545bf22ae4da7d655ba9fd';
    // var accessKey = 'c6c40b76-8119-4e93-81bf-bfb55417b392';
    // var secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';
    MeSomb.apiBase = 'http://127.0.0.1:8000';

    // test('testMakeDeposit', () async {
    //   MeSomb.apiBase = 'http://192.168.8.101:8000';
    //   var operation = PaymentOperation(
    //       'fishf',
    //       'c6c40b76-8119-4e93-81bf-bfb55417b392',
    //       'fe8c2445-810f-4caa-95c9-778d51580163');
    //   await operation.makeDeposit({
    //     'amount': 100,
    //     'receiver': '6775539049',
    //     'service': 'MTN',
    //     'nonce': 'jkfdkajd'
    //   });
    // });

    test('testMakeDepositWithNotFoundService', () {
      var operation =
          PaymentOperation('${applicationKey}f', accessKey, secretKey);

      expect(
          () async => await operation.makeDeposit(
              amount: 100, receiver: '6775539049', service: 'MTN'),
          throwsA(isA<ServiceNotFoundException>()));
    });

    test('testMakeDepositWithPermissionDenied', () {
      // MeSomb.apiBase = 'http://192.168.8.104:8000';
      var operation =
          PaymentOperation(applicationKey, 'f$accessKey', secretKey);
      expect(
          () async => await operation.makeDeposit(
              amount: 100, receiver: '6775539049', service: 'MTN'),
          throwsA(isA<PermissionDeniedException>()));
    });

    test('Should make payment test with invalid amount', () {
      // MeSomb.apiBase = 'http://192.168.8.104:8000';
      var operation = PaymentOperation(applicationKey, accessKey, secretKey);
      expect(
          () async => await operation.makeDeposit(
              amount: 5, receiver: '6775539049', service: 'MTN'),
          throwsA(isA<InvalidClientRequestException>()));
    });

    test('testMakeDepositSuccess', () async {
      var operation = PaymentOperation(applicationKey, accessKey, secretKey);
      var response = await operation.makeDeposit(
          amount: 100, service: 'MTN', receiver: '237677553904');
      expect(response.success, isTrue);
      expect(response.status, equals('SUCCESS'));
      expect(response.transaction.amount, equals(100));
      expect(response.transaction.fees, equals(2.0));
      expect(response.transaction.service, equals('MTN'));
      expect(response.transaction.bParty, equals('237677553904'));
      expect(response.transaction.country, equals('CM'));
      expect(response.transaction.currency, equals('XAF'));
    });

    test('Should make deposit test with success with customer and product data',
        () async {
      var payment = PaymentOperation(applicationKey, accessKey, secretKey);
      var response = await payment.makeDeposit(
        amount: 100,
        service: 'MTN',
        receiver: '237677553904',
        nonce: RandomGenerator.nonce(),
        customer: {
          'phone': '+237677550439',
          'email': 'fisher.bank@gmail.com',
          'first_name': 'Fisher',
          'last_name': 'BANK'
        },
        products: [
          {'name': 'Sac a Dos', 'category': 'Sac'}
        ],
        location: {'town': 'Douala', 'country': 'Cameroun'},
      );
      expect(response.success, isTrue);
      expect(response.status, equals('SUCCESS'));
      expect(response.transaction.amount, equals(100));
      expect(response.transaction.fees, equals(2));
      expect(response.transaction.service, equals('MTN'));
      expect(response.transaction.bParty, equals('237677553904'));
      expect(response.transaction.country, equals('CM'));
      expect(response.transaction.currency, equals('XAF'));
      expect(response.transaction.customer?.phone, equals('+237677550439'));
      expect(response.transaction.customer?.email,
          equals('fisher.bank@gmail.com'));
      expect(response.transaction.customer?.firstName, equals('Fisher'));
      expect(response.transaction.customer?.lastName, equals('BANK'));
      expect(response.transaction.location?.town, equals('Douala'));
      expect(response.transaction.location?.country, equals('Cameroun'));
    });
    test('testMakeCollectWithNotFoundService', () {
      var operation =
          PaymentOperation('${applicationKey}f', accessKey, secretKey);

      expect(
          () async => await operation.makeCollect(
              amount: 100, payer: '237677553904', service: 'MTN'),
          throwsA(isA<ServiceNotFoundException>()));
    });

    test('testMakeCollectWithPermissionDenied', () {
      var operation =
          PaymentOperation(applicationKey, 'f$accessKey', secretKey);
      expect(
          () async => await operation.makeCollect(
              amount: 100, payer: '237677553904', service: 'MTN'),
          throwsA(isA<PermissionDeniedException>()));
    });

    test('testMakeCollectSuccess', () async {
      var operation = PaymentOperation(applicationKey, accessKey, secretKey);
      var response = await operation.makeCollect(
          amount: 100, payer: '237677553904', service: 'MTN', trxID: '1');
      expect(response.success, isTrue);
      expect(response.status, equals('SUCCESS'));
      expect(response.transaction.amount, equals(98));
      expect(response.transaction.fees, equals(2));
      expect(response.transaction.service, equals('MTN'));
      expect(response.transaction.bParty, equals('237677553904'));
      expect(response.transaction.country, equals('CM'));
      expect(response.transaction.currency, equals('XAF'));
      expect(response.transaction.reference, equals('1'));
    });

    test('Should make collect test with success with customer and product data',
        () async {
      var customer = {
        'phone': '237677553904',
        'email': 'fisher.bank@gmail.com',
        'first_name': 'Fisher',
        'last_name': 'BANK'
      };
      var location = {'town': 'Douala', 'country': 'Cameroun'};
      var operation = PaymentOperation(applicationKey, accessKey, secretKey);
      var response = await operation.makeCollect(
          amount: 100,
          customer: customer,
          service: 'MTN',
          payer: '237677553904',
          nonce: RandomGenerator.nonce(),
          products: [
            {'name': 'Sac a Dos', 'category': 'Sac'}
          ],
          location: location);
      expect(response.success, isTrue);
      expect(response.status, equals('SUCCESS'));
      expect(response.transaction.amount, equals(98));
      expect(response.transaction.fees, equals(2));
      expect(response.transaction.service, equals('MTN'));
      expect(response.transaction.bParty, equals('237677553904'));
      expect(response.transaction.country, equals('CM'));
      expect(response.transaction.currency, equals('XAF'));
      expect(response.transaction.customer?.phone, equals('237677553904'));
      expect(response.transaction.customer?.email,
          equals('fisher.bank@gmail.com'));
      expect(response.transaction.customer?.firstName, equals('Fisher'));
      expect(response.transaction.customer?.lastName, equals('BANK'));
      expect(response.transaction.location?.town, equals('Douala'));
      expect(response.transaction.location?.country, equals('Cameroun'));
    });
    // test('Should make payment test with pending', () async {
    //   // MeSomb.apiBase = 'http://192.168.8.104:8000';
    //   var operation = PaymentOperation(
    //     '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
    //     'c6c40b76-8119-4e93-81bf-bfb55417b392',
    //     'fe8c2445-810f-4caa-95c9-778d51580163');
    //   var response = await operation.makeCollect({
    //     'amount': 100,
    //     'payer': '237677553904',
    //     'service': 'MTN',
    //     'nonce': RandomGenerator.nonce(),
    //     'trxID': '1',
    //     'mode': 'asynchronous'
    //   });
    //   expect(response.isTransactionSuccess(), isTrue);
    //   expect(response.isTransactionSuccess(), isFalse);
    // });

    // test('Should unset whitelist IP', () async {
    //   final operation = PaymentOperation( applicationKey, accessKey, secretKey, );
    //   final application =await operation.updateSecurity('whitelist_ips', 'UNSET');
    //   expect(application.security.whitelist_ips, isNull);
    // });

    // test('Should unset blacklist receiver', () async {
    //   final payment = PaymentOperation( applicationKey, accessKey, secretKey, );
    //   final application =await payment.updateSecurity('blacklist_receivers', 'UNSET');
    //   expect(application.security.blacklist_receivers, isNull);
    // });
    test('Should get status with not service found', () async {
      expect(
        () async {
          final payment = PaymentOperation(
              'f' '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
              'c6c40b76-8119-4e93-81bf-bfb55417b392',
              'fe8c2445-810f-4caa-95c9-778d51580163');
          await payment.getStatus();
        },
        throwsA(isA<ServiceNotFoundException>()),
      );
    });
    test('Should get status with not permission denied', () async {
      expect(
        () async {
          final payment = PaymentOperation(
              '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
              'f' 'c6c40b76-8119-4e93-81bf-bfb55417b392',
              'fe8c2445-810f-4caa-95c9-778d51580163');
          await payment.getStatus();
        },
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should get status success', () async {
      final payment = PaymentOperation(
          '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
          'c6c40b76-8119-4e93-81bf-bfb55417b392',
          'fe8c2445-810f-4caa-95c9-778d51580163');
      final response = await payment.getStatus();
      expect(response.name, equals('Meudocta Shop'));
    });

    test('Should get transactions with not service found', () async {
      expect(() async {
        final payment = PaymentOperation(
            'f' '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
            'c6c40b76-8119-4e93-81bf-bfb55417b392',
            'fe8c2445-810f-4caa-95c9-778d51580163');
        await payment.getTransactions(['c6c40b76-8119-4e93-81bf-bfb55417b392']);
      }, throwsA(isA<ServiceNotFoundException>()));
    });

    test('Should get transactions with not permission denied', () async {
      expect(() async {
        final payment = PaymentOperation(
            '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
            'f' 'c6c40b76-8119-4e93-81bf-bfb55417b392',
            'fe8c2445-810f-4caa-95c9-778d51580163');
        await payment.getTransactions(['c6c40b76-8119-4e93-81bf-bfb55417b392']);
      }, throwsA(isA<PermissionDeniedException>()));
    });

    test('Should get transactions success', () async {
      final payment = PaymentOperation(
          '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
          'c6c40b76-8119-4e93-81bf-bfb55417b392',
          'fe8c2445-810f-4caa-95c9-778d51580163');
      final response = await payment
          .getTransactions(['d265b9d5-b623-408a-bb92-9febdd9a1666', 'd265b9d5-b623-408a-bb92-9febdd9a1666']);
      expect(response.length, equals(1));
      expect(response[0].pk, equals('d265b9d5-b623-408a-bb92-9febdd9a1666'));
    });

    test('Should get transactions success with nonce', () async {
      final payment = PaymentOperation(
          '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
          'c6c40b76-8119-4e93-81bf-bfb55417b392',
          'fe8c2445-810f-4caa-95c9-778d51580163');
      final response = await payment.getTransactions(
          ['301930f5-4789-44d9-b2d7-3f917b97dc00']);
      expect(response.length, equals(1));
      expect(response[0].pk, equals('301930f5-4789-44d9-b2d7-3f917b97dc00'));
    });

    // test('Should generate generate link', () async {
    //   final payment = PaymentOperation(
    //       '2bb525516ff374bb52545bf22ae4da7d655ba9fd',
    //       'c6c40b76-8119-4e93-81bf-bfb55417b392',
    //       'fe8c2445-810f-4caa-95c9-778d51580163');
    //   final link = payment.generatePaymentLink({
    //     'amount': 100,
    //     'callback': 'https://mesomb.cm/callback',
    //     'nonce': RandomGenerator.nonce(),
    //   });
    //   print(link);
    // });
  });
}
