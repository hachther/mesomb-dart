import 'package:PaymentMeSomb/src/Exception/PermissionDeniedException.dart';
import 'package:PaymentMeSomb/src/Exception/ServiceNotFoundException.dart';
import 'package:PaymentMeSomb/src/Operation/MeSomb.dart';
import 'package:PaymentMeSomb/src/Operation/PaymentOperation.dart';
import 'package:PaymentMeSomb/src/util/RandomGenerator.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';  



 void main() {
  group('PayementOperation', () 
  {
    var applicationKey = '2bb525516ff374bb52545bf22ae4da7d655ba9fd';
    var accessKey = 'c6c40b76-8119-4e93-81bf-bfb55417b392';
    var secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';
    MeSomb.apiBase = 'http://192.168.8.101:8000';


    // test('testMakeDeposit', () async {
    //   MeSomb.apiBase = 'http://192.168.8.102:8000';
    //   var operation = PaymentOperation('fishf', 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    //   await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'jkfdkajd'});
    // });

    test('testMakeDepositWithNotFoundService', ()
    {
      var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd' + 'f', 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    
 
    expect(() async => await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'jkfdkajd'}),throwsA(isA<ServiceNotFoundException>() ));
    });

    test('testMakeDepositWithPermissionDenied', ()
    {
      // MeSomb.apiBase = 'http://192.168.8.104:8000';
      var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd', 'f' + 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    expect(() async => await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'jkfdkajd'}),throwsA(isA<PermissionDeniedException>() ));

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
        
        



        // customer.keys.forEach(key {

        // expect(response.transaction.customer[key], equals(customer[key]));
        // });
        // location.keys.forEach(key {
        // expect(response.transaction.location[key], equals(location[key]));
        // });
        // expect(response.transaction.products?.length, equals(1));
        // // ignore
        // expect(response.transaction.products[0].name, equals('Sac a Dos'));
        // // ignore
        // expect(response.transaction.products[0].category, equals('Sac'));
        // // ignore
        // // expect(response.transaction.products[0].quantity, equals(1));
        // // ignore
        // // expect(response.transaction.products[0].amount, equals(100));
    });
    
  });
   
}



