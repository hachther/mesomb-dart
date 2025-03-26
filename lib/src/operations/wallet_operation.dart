import 'package:mesomb/src/models/paginated_transactions.dart';
import 'package:mesomb/src/models/paginated_wallets.dart';
import 'package:mesomb/src/models/wallet.dart';
import 'package:mesomb/src/operations/base_operation.dart';

import '../models/wallet_transaction.dart';
import '../utils/random_generator.dart';

class WalletOperation extends AOperation {
  @override
  String service = 'wallet';

  /// Create a new instance of [FundraisingOperation]
  ///
  /// [providerKey], [accessKey] and [secretKey] are required to make a fundraising.
  /// You can specify the [language] of the operation if not 'en' will be value by default.
  WalletOperation(super.providerKey, super.accessKey, super.secretKey, {super.language});

  /// Create a new wallet with the following KYCs: [firstName], [lastName], [email], [phoneNumber], [country] and [gender].
  ///
  /// You can specify and unique [number] and if not MeSomb will generate one for you.
  Future<Wallet> createWallet({
    String? firstName,
    required String lastName,
    String? email,
    required String phoneNumber,
    String? country = 'CM',
    required String gender,
    String? nonce,
    String? number,
  }) async {
    const endpoint = 'wallet/wallets/';

    var body = {
      'last_name': lastName,
      if (firstName != null) 'first_name': firstName,
      if (email != null) 'email': email,
      'phone_number': phoneNumber,
      'country': country,
      'gender': gender,
      if (number != null) 'number': number,
    };

    return Wallet(await executeRequest('POST', endpoint, DateTime.now(), nonce ?? RandomGenerator.nonce(), body, 'synchronous'));
  }

  /// Get a wallet by its [id]
  Future<Wallet> getWallet(int id) async {
    String endpoint = "wallet/wallets/$id/";

    return Wallet(await executeRequest('GET', endpoint, DateTime.now(), RandomGenerator.nonce(), null, 'synchronous'));
  }

  /// Get all wallets with pagination support. You can specify the [page] to get a specific page.
  Future<PaginatedWallets> getWallets([int? page = 1]) async {
    String endpoint = "wallet/wallets/?page=$page";

    return PaginatedWallets(await executeRequest('GET', endpoint, DateTime.now(), RandomGenerator.nonce(), null, 'synchronous'));
  }

  /// Update a wallet by its [id] with the following KYCs: [firstName], [lastName], [email], [phoneNumber], [country] and [gender].
  Future<Wallet> updateWallet(int id, {
    String? firstName,
    required String lastName,
    String? email,
    required String phoneNumber,
    String? country = 'CM',
    required String gender,
    String? nonce,
  }) async {
    var endpoint = "wallet/wallets/$id/";

    var body = {
      'last_name': lastName,
      if (firstName != null) 'first_name': firstName,
      if (email != null) 'email': email,
      'phone_number': phoneNumber,
      'country': country,
      'gender': gender,
    };

    return Wallet(await executeRequest('PUT', endpoint, DateTime.now(), nonce ?? RandomGenerator.nonce(), body, 'synchronous'));
  }

  /// Delete a wallet by its [id]
  Future<void> deleteWallet(int id) async {
    String endpoint = "wallet/wallets/$id/";

    await executeRequest('DELETE', endpoint, DateTime.now(), RandomGenerator.nonce(), null, 'synchronous');
  }

  /// Remove money from a wallet.
  Future<WalletTransaction> removeMoney(int wallet, double amount, {bool force = false, String? message, String? externalId}) async {
    String endpoint = "wallet/wallets/$wallet/adjust/";

    var body = {
      'amount': amount,
      'direction': -1,
      'force': force,
    };

    if (message != null) {
      body['message'] = message;
    }

    if (externalId != null) {
      body['trxID'] = externalId;
    }

    return WalletTransaction(await executeRequest('POST', endpoint, DateTime.now(), RandomGenerator.nonce(), body, 'synchronous'));
  }

  /// Add money to a wallet.
  Future<WalletTransaction> addMoney(int wallet, double amount, {String? message, String? externalId}) async {
    String endpoint = "wallet/wallets/$wallet/adjust/";

    Map<String, dynamic> body = {
      'amount': amount,
      'direction': 1,
    };

    if (message != null) {
      body['message'] = message;
    }

    if (externalId != null) {
      body['trxID'] = externalId;
    }

    return WalletTransaction(await executeRequest('POST', endpoint, DateTime.now(), RandomGenerator.nonce(), body, 'synchronous'));
  }

  /// Transfer money from a wallet to another wallet.
  Future<WalletTransaction> transferMoney(int from, int to, double amount, {bool force = false, String? message, String? externalId}) async {
    String endpoint = "wallet/wallets/$from/transfer/";

    Map<String, dynamic> body = {
      'to': to,
      'amount': amount,
      'force': force,
    };

    if (message != null) {
      body['message'] = message;
    }

    if (externalId != null) {
      body['trxID'] = externalId;
    }

    return WalletTransaction(await executeRequest('POST', endpoint, DateTime.now(), RandomGenerator.nonce(), body, 'synchronous'));
  }

  /// Get a transaction by its [id]
  Future<WalletTransaction> getTransaction(int id) async {
    String endpoint = "wallet/transactions/$id/";

    return WalletTransaction(await executeRequest('GET', endpoint, DateTime.now(), RandomGenerator.nonce(), null, 'synchronous'));
  }

  /// Get all transactions with pagination support. You can specify the [page] to get a specific page.
  Future<PaginatedTransactions> listTransactions({int? page = 1, int? wallet}) async {
    String endpoint = "wallet/transactions/?page=$page";
    if (wallet != null) {
      endpoint += "&wallet=$wallet";
    }

    return PaginatedTransactions(await executeRequest('GET', endpoint, DateTime.now(), RandomGenerator.nonce(), null, 'synchronous'));
  }

  /// Get transactions from the [ids] list.
  /// You must set [source] to specified the origin of the IDs: MESOMB if the IDs are from MeSomb otherwise EXTERNAL.
  Future<List<WalletTransaction>> getTransactions(List<String> ids, [String source = 'MESOMB']) async {
    String endpoint = "wallet/transactions/search/?${ids.map((e) => 'ids=$e').join('&')}&source=$source";

    return (await executeRequest(
        'GET', endpoint, DateTime.now(), RandomGenerator.nonce(), null, null))
        .map((d) => WalletTransaction(d))
        .toList()
        .cast<WalletTransaction>();
  }
}