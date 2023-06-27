<h1 style="text-align: center">Welcome to dart-mesomb 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://mesomb.hachther.com/en/api/v1.1/schema/" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/hachther" target="_blank">
    <img alt="Twitter: hachther" src="https://img.shields.io/twitter/follow/hachther.svg?style=social" />
  </a>
</p>

> dart client for mobile payment (Orange Money, Mobile Money ...) with MeSomb services.
>
> You can check the full [documentation of the api here](https://mesomb.hachther.com/en/api/v1.1/schema/)

### 🏠 [Homepage](https://mesomb.com)

## Install

```sh
dart pub add mesomb_dart

```

## Usage

Check the full documentation [here](docs.md)

Below some quick examples

### Collect money from an account

ES6 import

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
 final payment = PaymentOperation(
  applicationKey: '<applicationKey>',
  accessKey: '<AccessKey>',
  secretKey: '<SecretKey>',
 );
 final response = await payment.makeCollect(
  amount: 100,
  service: 'MTN',
  payer: '677550203',
  nonce: RandomGenerator.nonce(),
 );
 print(response.isOperationSuccess());
 print(response.isTransactionSuccess());
}
```

Modular include

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
final payment = PaymentOperation(
    applicationKey: '<applicationKey>',
    accessKey: '<AccessKey>',
    secretKey: '<SecretKey>',
);
final response = await payment.makeCollect(
    amount: 100,
    service: 'MTN',
    payer: '677550203',
    nonce: RandomGenerator.nonce(),
);
print(response.isOperationSuccess());
print(response.isTransactionSuccess());
}
```

### Depose money in an account

ES6 import

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
 final payment = PaymentOperation(
  applicationKey: '<applicationKey>',
  accessKey: '<AccessKey>',
  secretKey: '<SecretKey>',
 );
 final response = await payment.makeDeposit(
  amount: 100,
  service: 'MTN',
  receiver: '677550203',
  nonce: RandomGenerator.nonce(),
 );
 print(response.isOperationSuccess());
 print(response.isTransactionSuccess());
}
```

Modular include

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
 final payment = PaymentOperation(
  applicationKey: '<applicationKey>',
  accessKey: '<AccessKey>',
  secretKey: '<SecretKey>',
 );
 final response = await payment.makeDeposit(
  amount: 100,
  service: 'MTN',
  receiver: '677550203',
  nonce: RandomGenerator.nonce(),
 );
 print(response.isOperationSuccess());
 print(response.isTransactionSuccess());
}
```

### Get application status

ES6 import

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
 final payment = PaymentOperation(
  applicationKey: '<applicationKey>',
  accessKey: '<AccessKey>',
  secretKey: '<SecretKey>',
 );
 final application = await payment.getStatus();
 print(application);
}
```

Modular include

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
  final payment = PaymentOperation(
    applicationKey: '<applicationKey>',
    accessKey: '<AccessKey>',
    secretKey: '<SecretKey>',
  );
  final application = await payment.getStatus();
  print(application);
}
```

### Get transactions by IDs

ES6 import

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
  var payment = PaymentOperation(
    applicationKey: '<applicationKey>',
    accessKey: '<AccessKey>',
    secretKey: '<SecretKey>',
  );

  var transactions = await payment.getTransactions(['ID1', 'ID2']);

  print(transactions);
}

```

Modular include

```dart
import 'package:mesomb/mesomb.dart';

void main() async {
  var payment = PaymentOperation(
    applicationKey: '<applicationKey>',
    accessKey: '<AccessKey>',
    secretKey: '<SecretKey>',
  );

  var transactions = await payment.getTransactions(['ID1', 'ID2']);

  print(transactions);
}

```

## Author

👤 **Hachther LLC <contact@hachther.com>**

* Website: https://www.hachther.com
* Twitter: [@hachther](https://twitter.com/hachther)
* Github: [@hachther](https://github.com/hachther)
* LinkedIn: [@hachther](https://linkedin.com/in/hachther)

## Show your support

Give a ⭐️ if this project helped you!
