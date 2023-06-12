
import 'package:PaymentMeSomb/src/Exception/InvalidClientRequestException.dart';
import 'package:PaymentMeSomb/src/Exception/PermissionDeniedException.dart';
import 'package:PaymentMeSomb/src/Exception/ServiceNotFoundException.dart';
import 'package:PaymentMeSomb/src/Model/Transaction.dart';
import 'package:PaymentMeSomb/src/Operation/MeSomb.dart';
import 'package:PaymentMeSomb/src/Operation/PaymentOperation.dart';
import 'package:PaymentMeSomb/src/util/RandomGenerator.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  group('PayementOperation', () {
    var applicationKey = '2bb525516ff374bb52545bf22ae4da7d655ba9fd';
    var accessKey = 'c6c40b76-8119-4e93-81bf-bfb55417b392';
    var secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';
    MeSomb.apiBase = 'http://192.168.8.99:8000';

    test('testMakeDeposit', () async {
      MeSomb.apiBase = 'http://192.168.8.102:8000';
      var operation = PaymentOperation('fishf', 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
      await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'jkfdkajd'});
    });

    test('testMakeDepositWithNotFoundService', ()
    {
      var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd' + 'f', 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');

    expect(() async => await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'lkakdio90fsd8fsf'}),throwsA(isA<ServiceNotFoundException>() ));
    });

    test('testMakeDepositWithPermissionDenied', ()
    {
      // MeSomb.apiBase = 'http://192.168.8.104:8000';
      var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd', 'f' + 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    expect(() async => await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'lkakdio90fsd8fsf'}),throwsA(isA<PermissionDeniedException>() ));

    });
    test('Should make payment test with invalid amount', ()
    {
      // MeSomb.apiBase = 'http://192.168.8.104:8000';
      var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd', 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    expect(() async => await operation.makeDeposit({'amount': 5, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'lkakdio90fsd8fsf'}),throwsA(isA<InvalidClientRequestException>() ));

    });

    // test('testMakeDepositSuccess', () async {
    //   MeSomb.apiBase = 'http://192.168.8.101:8000';
    //   var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd','c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    //   var response = await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'jkfdkajd'});
    // });
    test('testMakeDepositSuccess', () async {
      var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd','c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
      var response = await operation.makeDeposit({'amount': 100, 'receiver': '237677553904', 'service': 'MTN', 'nonce': RandomGenerator.nonce()});
        expect(response.success, isTrue);
        expect(response.status, equals('SUCCESS'));
        expect(response.transaction.amount, equals(100));
        expect(response.transaction.fees, equals(0));
        expect(response.transaction.service, equals('MTN'));
        expect(response.transaction.b_party, equals('237677553904'));
        expect(response.transaction.country, equals('CM'));
        expect(response.transaction.currency, equals('XAF'));

    });
    test('Should make deposit test with success with customer and product data',() async
    {
        var customer = {
        'phone': '+237677550439',
        'email': 'fisher.bank@gmail.com',
        'first_name': 'Fisher',
        'last_name': 'BANK'
        };
        var location = {'town': 'Douala', 'country': 'Cameroun'};
        var payment = PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd','c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
        var response = await payment.makeDeposit({'amount':100, 'customer': customer,'service': 'MTN', 'receiver': 237677553904, 'nonce': RandomGenerator.nonce(), 'products': [
        {'name': 'Sac a Dos', 'category': 'Sac'}],'location': location} );
        expect(response.success, isTrue);
        expect(response.status, equals('SUCCESS'));
        expect(response.transaction.amount, equals(100));
        expect(response.transaction.fees, equals(0));
        expect(response.transaction.service, equals('MTN'));
        expect(response.transaction.b_party, equals('237677553904'));
        expect(response.transaction.country, equals('CM'));
        expect(response.transaction.currency, equals('XAF'));
        expect(response.transaction.customer?.phone, equals('+237677550439'));
        expect(response.transaction.customer?.email, equals('fisher.bank@gmail.com'));
        expect(response.transaction.customer?.first_name, equals('Fisher'));
        expect(response.transaction.customer?.last_name, equals('BANK'));
        expect(response.transaction.location?.town, equals('Douala'));
        expect(response.transaction.location?.country, equals('Cameroun'));

      });
      test('testMakeCollectWithNotFoundService', () {
        var operation =
            PaymentOperation('${applicationKey}f', accessKey, secretKey);

        expect(
            () async => await operation.makeCollect({
                  'amount': 100,
                  'payer': '237677553904',
                  'service': 'MTN',
                  'nonce': 'lkakdio90fsd8fsf'
                }),
            throwsA(isA<ServiceNotFoundException>()));
      });

      test('testMakeCollectWithPermissionDenied', () {
        var operation =
            PaymentOperation(applicationKey, '${accessKey}f', secretKey);
        expect(
            () async => await operation.makeCollect({
                  'amount': 100,
                  'payer': '237677553904',
                  'service': 'MTN',
                  'nonce': 'lkakdio90fsd8fsf'
                }),
            throwsA(isA<PermissionDeniedException>()));
      });
      test('Should make payment test with invalid amount', () {
        var operation = PaymentOperation(applicationKey, accessKey, secretKey);
        expect(
            () async => await operation.makeCollect({
                  'amount': 5,
                  'payer': '237677553904',
                  'service': 'MTN',
                  'nonce': 'lkakdio90fsd8fsf'
                }),
            throwsA(isA<InvalidClientRequestException>()));
      });
      test('testMakeCollectSuccess', () async {
        var operation = PaymentOperation(applicationKey, accessKey, secretKey);
        var response = await operation.makeCollect({
          'amount': 100,
          'payer': '237677553904',
          'service': 'MTN',
          'nonce': RandomGenerator.nonce(),
          'trxID': '1'
        });
        expect(response.success, isTrue);
        expect(response.status, equals('SUCCESS'));
        expect(response.transaction.amount, equals(97));
        expect(response.transaction.fees, equals(3));
        expect(response.transaction.service, equals('MTN'));
        expect(response.transaction.b_party, equals('237677553904'));
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
        var payment = PaymentOperation(applicationKey, accessKey, secretKey);
        var response = await payment.makeCollect({
          'amount': 100,
          'customer': customer,
          'service': 'MTN',
          'payer': 237677553904,
          'nonce': RandomGenerator.nonce(),
          'products': [
            {'name': 'Sac a Dos', 'category': 'Sac'}
          ],
          'location': location
        });
        expect(response.success, isTrue);
        expect(response.status, equals('SUCCESS'));
        expect(response.transaction.amount, equals(97));
        expect(response.transaction.fees, equals(3));
        expect(response.transaction.service, equals('MTN'));
        expect(response.transaction.b_party, equals('237677553904'));
        expect(response.transaction.country, equals('CM'));
        expect(response.transaction.currency, equals('XAF'));
        expect(response.transaction.customer?.phone, equals('237677553904'));
        expect(response.transaction.customer?.email,
            equals('fisher.bank@gmail.com'));
        expect(response.transaction.customer?.first_name, equals('Fisher'));
        expect(response.transaction.customer?.last_name, equals('BANK'));
        expect(response.transaction.location?.town, equals('Douala'));
        expect(response.transaction.location?.country, equals('Cameroun'));
      });
      test('Should make payment test with pending', () async {
        // MeSomb.apiBase = 'http://192.168.8.104:8000';
        var operation = PaymentOperation(applicationKey, accessKey, secretKey);
        var response = await operation.makeCollect({
          'amount': 100,
          'payer': '237677553904',
          'service': 'MTN',
          'nonce': RandomGenerator.nonce(),
          'trxID': '1',
          'mode': 'asynchronous'
        });
        expect(response.isTransactionSuccess(), isTrue);
        expect(response.isTransactionSuccess(), isFalse);
      });

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
            '${applicationKey}f',
            accessKey,
            secretKey,
          );
          await payment.getStatus(DateTime.now());
        },
        throwsA(isA<ServiceNotFoundException>()),
      );
    });
    test('Should get status with not permission denied', () async {
      expect(
        () async {
          final payment =
              PaymentOperation(applicationKey, '${accessKey}f', secretKey);
          await payment.getStatus(DateTime.now());
        },
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should get status success', () async {
      final payment = PaymentOperation(
        applicationKey,
        accessKey,
        secretKey,
      );
      final response = await payment.getStatus(DateTime.now());
      expect(response.name, equals('Meudocta Shop'));
    });

    test('Should get transactions with not service found', () async {
      expect(() async {
        final payment =PaymentOperation('${applicationKey}f', accessKey, secretKey);
        await payment.getTransactions(['c6c40b76-8119-4e93-81bf-bfb55417b392'],null);}, throwsA(isA<ServiceNotFoundException>()));
    });

    test('Should get transactions with not permission denied', () async {
      expect(() async {
        final payment =
            PaymentOperation(applicationKey, '${accessKey}f', secretKey);
        await payment.getTransactions(['c6c40b76-8119-4e93-81bf-bfb55417b392'],null);
      }, throwsA(isA<PermissionDeniedException>()));
    });

    test('Should get transactions success', () async {
      final payment = PaymentOperation(applicationKey, accessKey, secretKey);
      final response = await payment.getTransactions(['9886f099-dee2-4eaa-9039-e92b2ee33353'],null);
      expect(response.length, equals(1));
      expect(response[0].pk, equals('9886f099-dee2-4eaa-9039-e92b2ee33353'));
    });

  });
}
