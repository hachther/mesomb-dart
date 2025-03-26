import 'package:mesomb/src/operations/base_operation.dart';
import 'package:mesomb/src/utils/random_generator.dart';

import '../models/application.dart';
import '../models/transaction.dart';
import '../models/transaction_response.dart';

class PaymentOperation extends AOperation {
  @override
  String service = 'payment';

  /// Create a new instance of [PaymentOperation]
  ///
  /// [applicationKey], [accessKey] and [secretKey] are required to make a payment.
  /// You can specify the [language] of the operation if not 'en' will be value by default.
  PaymentOperation(super.applicationKey, super.accessKey, super.secretKey, {super.language});

  /// Make a deposit
  ///
  /// Depose [amount] into [receiver] through the service [service].
  /// Your can specify the [country] and [currency] of the transaction if not CM and XAF will be value by default.
  /// If your deal with a foreign currency you can set [conversion] to true.
  /// Your can also set:
  ///   - [location]: Map containing the location of the customer with the following attributes: town, region and location all string.
  ///   - [products]: It is a List of products. Each product are Map with the following attributes: name string, category string, quantity int and amount float
  ///   - [customer]: Map containing information about the customer: phone string, email: string, first_name string, last_name string, address string, town string, region string and country string
  ///
  /// You can set [mode] to asynchronous if you want to make an asynchronous transaction.
  /// To prevent replay attack you can set a [nonce] to the transaction.
  ///
  /// The response will be a [TransactionResponse] object.
  Future<TransactionResponse> makeDeposit({
    required double amount,
    required String service,
    required String receiver,
    String? nonce,
    String? trxID,
    String? country = 'CM',
    String? currency = 'XAF',
    String? mode = 'synchronous',
    bool? conversion = false,
    Map<String, String>? location,
    Map<String, String>? customer,
    List<Map<String, dynamic>>? products
  }) async {
    String endpoint = 'payment/deposit/';

    Map<String, dynamic> body = {
      'amount': amount,
      'service': service,
      'receiver': receiver,
      'country': country,
      'currency': currency,
      'amount_currency': currency,
      if (trxID != null) 'trxID': trxID,
      if (location != null) 'location': location,
      if (customer != null) 'customer': customer,
      if (products != null) 'products': products,
    };

    return TransactionResponse(await executeRequest(
        'POST', endpoint, DateTime.now(), nonce ?? RandomGenerator.nonce(), body, mode));
  }

  /// Make a payment
  ///
  /// Make [payer] pay [amount] on the service [service].
  /// Your can specify the [country] and [currency] of the transaction if not CM and XAF will be value by default.
  /// If your deal with a foreign currency you can set [conversion] to true.
  /// Your can also set:
  ///   - [location]: Map containing the location of the customer with the following attributes: town, region and location all string.
  ///   - [products]: It is a List of products. Each product are Map with the following attributes: name string, category string, quantity int and amount float
  ///   - [customer]: Map containing information about the customer: phone string, email: string, first_name string, last_name string, address string, town string, region string and country string
  ///
  /// You can set [mode] to asynchronous if you want to make an asynchronous transaction.
  /// To prevent replay attack you can set a [nonce] to the transaction.
  ///
  /// The response will be a [TransactionResponse] object.
  Future<TransactionResponse> makeCollect({
    required double amount,
    required String service,
    required String payer,
    String? nonce,
    String? trxID,
    String? country = 'CM',
    String? currency = 'XAF',
    bool? fees = true,
    String? mode = 'synchronous',
    bool? conversion = false,
    Map<String, String>? location,
    Map<String, String>? customer,
    List<Map<String, dynamic>>? products
  }) async {
    final String endpoint = 'payment/collect/';

    Map<String, dynamic> body = {
      'amount': amount,
      'service': service,
      'payer': payer,
      'country': country,
      'currency': currency,
      'amount_currency': currency,
      'fees': fees,
      'conversion': conversion,
      if (trxID != null) 'trxID': trxID,
      if (location != null) 'location': location,
      if (customer != null) 'customer': customer,
      if (products != null) 'products': products,
    };

    return TransactionResponse(await executeRequest(
        'POST', endpoint, DateTime.now(), nonce ?? RandomGenerator.nonce(), body, mode));
  }

  /// Purchase airtime
  ///
  /// Depose [merchant]'s [amount] airtime into [receiver] account through the service [service].
  /// Your can specify the [country] and [currency] of the transaction if not CM and XAF will be value by default.
  /// If your deal with a foreign currency you can set [conversion] to true.
  /// Your can also set:
  ///   - [location]: Map containing the location of the customer with the following attributes: town, region and location all string.
  ///   - [products]: It is a List of products. Each product are Map with the following attributes: name string, category string, quantity int and amount float
  ///   - [customer]: Map containing information about the customer: phone string, email: string, first_name string, last_name string, address string, town string, region string and country string
  ///
  /// You can set [mode] to asynchronous if you want to make an asynchronous transaction.
  /// To prevent replay attack you can set a [nonce] to the transaction.
  ///
  /// The response will be a [TransactionResponse] object.
  Future<TransactionResponse> purchaseAirtime({
    required double amount,
    required String service,
    required String receiver,
    required String merchant,
    String? nonce,
    String? trxID,
    String? country = 'CM',
    String? currency = 'XAF',
    String? mode = 'synchronous',
    Map<String, String>? location,
    Map<String, String>? customer,
    List<Map<String, dynamic>>? products
  }) async {
    String endpoint = 'payment/airtime/';

    Map<String, dynamic> body = {
      'amount': amount,
      'service': service,
      'receiver': receiver,
      'merchant': merchant,
      'country': country,
      'currency': currency,
      'amount_currency': currency,
      if (trxID != null) 'trxID': trxID,
      if (location != null) 'location': location,
      if (customer != null) 'customer': customer,
      if (products != null) 'products': products,
    };

    return TransactionResponse(await executeRequest(
        'POST', endpoint, DateTime.now(), nonce ?? RandomGenerator.nonce(), body, mode));
  }

  /// Get the status of the application
  Future<Application> getStatus() async {
    const endpoint = 'payment/status/';

    return Application(
        await executeRequest('GET', endpoint, DateTime.now(), '', null, null));
  }

  /// Get transactions from the [ids] list.
  /// You must set [source] to specified the origin of the IDs: MESOMB if the IDs are from MeSomb otherwise EXTERNAL.
  Future<List<Transaction>> getTransactions(List<String> ids, {String source = 'MESOMB'}) async {
    final endpoint =
        "payment/transactions/?${ids.map((e) => 'ids=$e').join('&')}&source=$source";

    return (await executeRequest(
            'GET', endpoint, DateTime.now(), RandomGenerator.nonce(), null, null))
        .map((d) => Transaction(d))
        .toList()
        .cast<Transaction>();
  }

  /// Check transactions from the [ids] list.
  /// You must set [source] to specified the origin of the IDs: MESOMB if the IDs are from MeSomb otherwise EXTERNAL.
  Future<List<Transaction>> checkTransactions(List<String> ids,
      {String source = 'MESOMB'}) async {
    final endpoint =
        "payment/transactions/check/?${ids.map((e) => 'ids=$e').join('&')}&source=$source";

    return (await executeRequest(
            'GET', endpoint, DateTime.now(), '', null, null))
        .map((d) => Transaction(d))
        .toList()
        .cast<Transaction>();
  }

  /// Refund a transaction with the [id] to the payer of the transaction.
  /// You can specify the [amount] to refund if not the total amount will be refunded.
  /// You can also set the [currency] of the refund if in the original currency.
  Future<Transaction> refundTransaction(String id, {
    double? amount,
    String? nonce,
    String? currency = 'XAF',
    bool? conversion = false,
  }) async {
    final endpoint = 'payment/refund/';

    Map<String, dynamic> body = {
      'id': id,
      if (amount != null) 'amount': amount,
      'currency': currency,
      'amount_currency': currency,
      'conversion': conversion,
    };

    return Transaction(await executeRequest('POST', endpoint, DateTime.now(), RandomGenerator.nonce(), body, 'synchronous'));
  }
}
