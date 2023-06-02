import 'package:PaymentMeSomb/src/Exception/ServiceNotFoundException.dart';
import 'package:PaymentMeSomb/src/Operation/MeSomb.dart';
import 'package:PaymentMeSomb/src/Operation/PaymentOperation.dart';
import 'package:test/test.dart';  


// int Add(int x,int y)                
// { 
//    return x+y; 
// }  
// void main() { 
  
//    test("test to check add method",(){  
//       var expected = 30; 
      
//       var actual = Add(10,20); 
      
//       expect(actual,expected); 
//    }); 
// }


 void main() {
  group('PayementOperation', () 
  {
    var applicationKey = '2bb525516ff374bb52545bf22ae4da7d655ba9fd';
    var accessKey = 'c6c40b76-8119-4e93-81bf-bfb55417b392';
    var secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';

    // test('testMakeDeposit', () async {
    //   MeSomb.apiBase = 'http://192.168.8.102:8000';
    //   var operation = PaymentOperation('fishf', 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    //   await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'jkfdkajd'});
    // });

    test('testMakeDepositWithNotFoundService', ()
    {
      MeSomb.apiBase = 'http://192.168.8.101:8000';
      var operation =PaymentOperation('2bb525516ff374bb52545bf22ae4da7d655ba9fd' + 'f', 'c6c40b76-8119-4e93-81bf-bfb55417b392', 'fe8c2445-810f-4caa-95c9-778d51580163');
    
 
    expect(() async => await operation.makeDeposit({'amount': 100, 'receiver': '6775539049', 'service': 'MTN', 'nonce': 'jkfdkajd'}),throwsA(isA<ServiceNotFoundException>() ));
    });
    
});
   
}



