import 'package:mesomb/mesomb.dart';
import 'package:mesomb/src/exceptions/invalid_client_request_exception.dart';
import 'package:mesomb/src/exceptions/permission_denied_exception.dart';
import 'package:mesomb/src/exceptions/service_not_found_exception.dart';
import 'package:mesomb/src/mesomb.dart';
import 'package:test/test.dart';

String fundKey = 'fa78bded201b791712ee398c7ddfb8652669404f';
String accessKey = 'c6c40b76-8119-4e93-81bf-bfb55417b392';
String secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';

void main() {
  group('FundraisingOperation', () {
    // var fundKey = '2bb525516ff374bb52545bf22ae4da7d655ba9fd';
    // var accessKey = '0685831f-4145-4352-ae81-155fec42c748';
    // var secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';
    MeSomb.apiBase = 'http://127.0.0.1:8000';

    // test('tastMakeContribution', () async {
    //   MeSomb.apiBase = 'http://192.168.8.101:8000';
    //   var operation = FundraisingOperation(
    //       'fishf',
    //       '0685831f-4145-4352-ae81-155fec42c748',
    //       'fe8c2445-810f-4caa-95c9-778d51580163');
    //   await operation.makeDeposit({
    //     'amount': 100,
    //     'receiver': '6775539049',
    //     'service': 'MTN',
    //     'nonce': 'jkfdkajd'
    //   });
    // });

    test('tastMakeContributionWithNotFoundService', () {
      var operation =
      FundraisingOperation('${fundKey}f', accessKey, secretKey);

      expect(
              () async => await operation.makeContribution(
              amount: 100, payer: '6775539049', service: 'MTN'),
          throwsA(isA<ServiceNotFoundException>()));
    });

    test('tastMakeContributionWithPermissionDenied', () {
      // MeSomb.apiBase = 'http://192.168.8.104:8000';
      var operation =
      FundraisingOperation(fundKey, 'f$accessKey', secretKey);
      expect(
              () async => await operation.makeContribution(
              amount: 100, payer: '6775539049', service: 'MTN'),
          throwsA(isA<PermissionDeniedException>()));
    });

    test('Should make payment test with invalid amount', () {
      // MeSomb.apiBase = 'http://192.168.8.104:8000';
      var operation = FundraisingOperation(fundKey, accessKey, secretKey);
      expect(
              () async => await operation.makeContribution(
              amount: 5, payer: '6775539049', service: 'MTN'),
          throwsA(isA<InvalidClientRequestException>()));
    });

    test('tastMakeContributionSuccess', () async {
      var operation = FundraisingOperation(fundKey, accessKey, secretKey);
      var response = await operation.makeContribution(
        amount: 100,
        service: 'MTN',
        payer: '670000000',
        trxID: '1',
        fullName: {'first_name': 'John', 'last_name': 'Doe'},
        contact: {'email': 'contact@gmail.com', 'phone_number': '+237677550203'},
      );
      
      expect(response.success, isTrue);
      expect(response.status, equals('SUCCESS'));
      expect(response.isContributionSuccess(), isTrue);
      expect(response.contribution.amount, equals(98));
      expect(response.contribution.fees, equals(2));
      expect(response.contribution.service, equals('MTN'));
      expect(response.contribution.bParty, equals('237670000000'));
      expect(response.contribution.country, equals('CM'));
      expect(response.contribution.currency, equals('XAF'));
      expect(response.contribution.reference, equals('1'));
      expect(response.contribution.contributor!.firstName, equals('John'));
      expect(response.contribution.contributor!.lastName, equals('Doe'));
      expect(response.contribution.contributor!.email, equals('contact@gmail.com'));
      expect(response.contribution.contributor!.phone, equals('+237677550203'));
      expect(response.contribution.getData(), isNotNull);
    });

    test('tastMakeContributionSuccess', () async {
      var operation = FundraisingOperation(fundKey, accessKey, secretKey);
      var response = await operation.makeContribution(
        amount: 100,
        service: 'MTN',
        payer: '670000000',
        trxID: '1',
        anonymous: true,
      );

      expect(response.success, isTrue);
      expect(response.status, equals('SUCCESS'));
      expect(response.isContributionSuccess(), isTrue);
      expect(response.contribution.amount, equals(98));
      expect(response.contribution.fees, equals(2));
      expect(response.contribution.service, equals('MTN'));
      expect(response.contribution.bParty, equals('237670000000'));
      expect(response.contribution.country, equals('CM'));
      expect(response.contribution.currency, equals('XAF'));
      expect(response.contribution.reference, equals('1'));
      expect(response.contribution.contributor, isNull);
      expect(response.contribution.getData(), isNotNull);
    });

    test('Should get transactions success', () async {
      var operation = FundraisingOperation(fundKey, accessKey, secretKey);
      final response = await operation
          .getContributions(['0685831f-4145-4352-ae81-155fec42c748']);
      expect(response.length, equals(1));
      expect(response[0].pk, equals('0685831f-4145-4352-ae81-155fec42c748'));
    });

    test('Should check transactions success', () async {
      var operation = FundraisingOperation(fundKey, accessKey, secretKey);
      final response = await operation.checkContributions(
          ['0685831f-4145-4352-ae81-155fec42c748']);
      expect(response.length, equals(1));
      expect(response[0].pk, equals('0685831f-4145-4352-ae81-155fec42c748'));
    });
  });
}