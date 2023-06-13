<h1 style="text-align: center">Bienvenue sur dart-mesomb </h1>
<p>
<img alt="Version" src="<a href="https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000">https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000</a>" />
<a href="<a href="https://mesomb.hachther.com/en/api/v1.1/schema/">https://mesomb.hachther.com/en/api/v1.1/schema/</a>" target="_blank">
<img alt="Documentation" src="<a href="https://img.shields.io/badge/documentation-yes-brightgreen.svg">https://img.shields.io/badge/documentation-yes-brightgreen.svg</a>" />
</a>
<a href="#" target="_blank">
<img alt="License: MIT" src="<a href="https://img.shields.io/badge/License-MIT-yellow.svg">https://img.shields.io/badge/License-MIT-yellow.svg</a>" />
</a>
<a href="<a href="https://twitter.com/hachther">https://twitter.com/hachther</a>" target="_blank">
<img alt="Twitter: hachther" src="<a href="https://img.shields.io/twitter/follow/hachther.svg?style=social">https://img.shields.io/twitter/follow/hachther.svg?style=social</a>" />
</a>
</p>

> Client Dart pour le paiement mobile (Orange Money, Mobile Money ...) avec les services MeSomb.
>
> Vous pouvez consulter la <a href="https://mesomb.hachther.com/en/api/v1.1/schema/">documentation complète de l'api ici</a>

house
 <a href="https://mesomb.com">Page d'accueil</a>
Installer
sh
yarn add @hachther/mesomb

ou
npm install @hachther/mesomb

Utilisation
Consultez la documentation complète ici

Voici quelques exemples rapides

Collecter de l'argent depuis un compte
Importation ES6

Dart
import 'package:mesomb/mesomb.dart';

final payment = PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final response = await payment.makeCollect(amount: 100, service: 'MTN', payer: '677550203', nonce: RandomGenerator.nonce());
print(response.isOperationSuccess());
print(response.isTransactionSuccess());

Inclusion modulaire

Dart
import 'package:mesomb/mesomb.dart' as mesomb;

final payment = mesomb.PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final response = await payment.makeCollect(amount: 100, service: 'MTN', payer: '677550203', nonce: mesomb.RandomGenerator.nonce());
print(response.isOperationSuccess());
print(response.isTransactionSuccess());

Déposer de l'argent dans un compte
Importation ES6

Dart
import 'package:mesomb/mesomb.dart';

final payment = PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final response = await payment.makeDeposit(amount: 100, service: 'MTN', receiver: '677550203', nonce: RandomGenerator.nonce());
print(response.isOperationSuccess());
print(response.isTransactionSuccess());

Inclusion modulaire

Dart
import 'package:mesomb/mesomb.dart' as mesomb;

final payment = mesomb.PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final response = await payment.makeDeposit(amount: 100, service: 'MTN', receiver: '677550203', nonce: mesomb.RandomGenerator.nonce());
print(response.isOperationSuccess());
print(response.isTransactionSuccess());

Obtenir le statut de l'application
Importation ES6

Dart
import 'package:mesomb/mesomb.dart';

final payment = PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final application = await payment.getStatus();
print(application);

Inclusion modulaire

Dart
import 'package:mesomb/mesomb.dart' as mesomb;

final payment = mesomb.PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final application = await payment.getStatus();
print(application);

Obtenir les transactions par ID
Importation ES6

Dart
import 'package:mesomb/mesomb.dart';

final payment = PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final transactions = await payment.getTransactions(['ID1', 'ID2']);
print(transactions);

Inclusion modulaire

Dart
import 'package:mesomb/mesomb.dart' as mesomb;

final payment = mesomb.PaymentOperation(applicationKey: '<applicationKey>', accessKey: '<AccessKey>', secretKey: '<SecretKey>');
final transactions = await payment.getTransactions(['ID1', 'ID2']);
print(transactions);

Auteur
Hachther LLC <contact@hachther.com>

⦁ 
Site web : <a href="https://www.hachther.com">https://www.hachther.com</a>
⦁ 
Twitter : <a href="https://twitter.com/hachther">@hachther</a>
⦁ 
Github : <a href="https://github.com/hachther">@hachther</a>
⦁ 
LinkedIn : <a href="https://linkedin.com/in/hachther">@hachther</a>

