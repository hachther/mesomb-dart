import 'package:mesomb/src/mesomb.dart';
import 'package:mesomb/src/models/paginated_transactions.dart';
import 'package:mesomb/src/models/paginated_wallets.dart';
import 'package:mesomb/src/models/wallet.dart';
import 'package:mesomb/src/models/wallet_transaction.dart';
import 'package:mesomb/src/operations/wallet_operation.dart';
import 'package:test/test.dart';

String providerKey = 'a1dc7a7391c538788043';
String accessKey = 'c6c40b76-8119-4e93-81bf-bfb55417b392';
String secretKey = 'fe8c2445-810f-4caa-95c9-778d51580163';

void main() {
  group('WalletOperation', () {
    MeSomb.apiBase = 'http://127.0.0.1:8000';

    test('testCreateNewWallet', () async {
      var client = WalletOperation(providerKey, accessKey, secretKey);
      Wallet wallet = await client.createWallet(
        firstName: 'John',
        lastName: 'Doe',
        email: 'contact@gmail.com',
        phoneNumber: '+237677550000',
        country: 'CM',
        gender: 'MAN'
      );
      expect(wallet.firstName, 'John');
      expect(wallet.lastName, 'Doe');
      expect(wallet.email, 'contact@gmail.com');
      expect(wallet.phoneNumber, '+237677550000');
      expect(wallet.country, 'CM');
      expect(wallet.gender, 'MAN');
      expect(wallet.number, isNotNull);
    });
  });

  test('testCreateNewWalletWithMin', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    Wallet wallet = await client.createWallet(
        lastName: 'Doe',
        phoneNumber: '+237677550000',
        gender: 'MAN'
    );
    expect(wallet.lastName, 'Doe');
    expect(wallet.phoneNumber, '+237677550000');
    expect(wallet.gender, 'MAN');
    expect(wallet.number, isNotNull);
  });

  test('testUpdateWalletWithMin', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    Wallet wallet = await client.updateWallet(229,
        lastName: 'Doe',
        phoneNumber: '+237677550087',
        gender: 'WOMAN'
    );
    expect(wallet.id, 229);
    expect(wallet.lastName, 'Doe');
    expect(wallet.phoneNumber, '+237677550087');
    expect(wallet.gender, 'WOMAN');
    expect(wallet.number, isNotNull);
  });

  test('testGetWallet', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    Wallet wallet = await client.getWallet(228);

    expect(wallet.id, 228);
    expect(wallet.firstName, 'John');
    expect(wallet.lastName, 'Doe');
    expect(wallet.email, 'contact@gmail.com');
    expect(wallet.phoneNumber, '+237677550000');
    expect(wallet.country, 'CM');
    expect(wallet.gender, 'MAN');
    expect(wallet.number, isNotNull);
  });

  test('testGetWallets', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    PaginatedWallets wallets = await client.getWallets();

    expect(wallets.count, greaterThan(0));
    // expect(wallet.next).not.toBeNull();
    expect(wallets.previous, isNull);
    expect(wallets.results.length, greaterThan(0));
  });

  test('testAddMoneyToWallet', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    Wallet wallet = await client.getWallet(228);
    WalletTransaction transaction = await client.addMoney(228, 1000);
    expect(transaction.direction, 1);
    expect(transaction.status, 'SUCCESS');
    expect(transaction.amount, 1000);
    expect(transaction.balanceAfter, (wallet.balance ?? 0) + 1000);
    expect(transaction.wallet, 228);
    expect(transaction.country, 'CM');
    expect(transaction.finTrxId, isNotNull);
    expect(transaction.date, isNotNull);
  });

  test('testRemoveMoneyToWallet', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    Wallet wallet = await client.getWallet(228);
    WalletTransaction transaction = await client.removeMoney(228, 1000);
    expect(transaction.direction, -1);
    expect(transaction.status, 'SUCCESS');
    expect(transaction.amount, 1000);
    expect(transaction.balanceAfter, (wallet.balance ?? 0) - 1000);
    expect(transaction.wallet, 228);
    expect(transaction.country, 'CM');
    expect(transaction.finTrxId, isNotNull);
    expect(transaction.date, isNotNull);
  });

  test('testGetWalletTransaction', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    WalletTransaction transaction = await client.getTransaction(3061);
    expect(transaction.id, isNotNull);
    expect(transaction.direction, -1);
    expect(transaction.status, 'SUCCESS');
    expect(transaction.amount, 1000);
    expect(transaction.balanceAfter, 1000);
    expect(transaction.wallet, 228);
    expect(transaction.country, 'CM');
    expect(transaction.finTrxId, isNotNull);
    expect(transaction.date, isNotNull);
  });

  test('testListWalletTransactions', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    PaginatedTransactions transactions = await client.listTransactions();
    expect(transactions.count, greaterThan(0));
    // expect(wallet.next).not.toBeNull();
    expect(transactions.previous, isNull);
    expect(transactions.results.length, greaterThan(0));
  });

  test('testListWalletTransactionsWithWallet', () async {
    var client = WalletOperation(providerKey, accessKey, secretKey);
    PaginatedTransactions transactions = await client.listTransactions(page: 1, wallet: 228);
    expect(transactions.count, greaterThan(0));
    // expect(wallet.next).not.toBeNull();
    expect(transactions.previous, isNull);
    expect(transactions.results.length, greaterThan(0));
  });
}