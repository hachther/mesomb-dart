import 'dart:convert';

import '../Model/application.dart';
import '../Model/transaction.dart';
import 'package:http/http.dart' as http;

import '../Exception/invalid_client_request_exception.dart';
import '../Exception/permission_denied_exception.dart';
import '../Exception/server_exception.dart';
import '../Exception/service_not_found_exception.dart';
import '../Model/transaction_response.dart';
import '../mesomb.dart';
import '../signature.dart';

class PaymentOperation {
  late String applicationKey;
  late String accessKey;
  late String secretKey;

  PaymentOperation(this.applicationKey, this.accessKey, this.secretKey);

  String _buildUrl(String endpoint) {
    String host = MeSomb.apiBase;
    String apiVersion = MeSomb.apiVersion;
    return "$host/api/$apiVersion/$endpoint";
  }

  String _getAuthorization(String method, String endpoint, DateTime date,
      String nonce, Map<String, String>? headers, Map<String, dynamic>? body) {
    String url = _buildUrl(endpoint);

    Map<String, String> credentials = {
      'accessKey': accessKey,
      'secretKey': secretKey
    };

    return Signature.signRequest(
        'payment', method, url, date, nonce, credentials, headers, body);
  }

  void _processClientException(int statusCode, String response) {
    String? code;
    String message = response;
    if (response.startsWith("{")) {
      Map<String, dynamic> data = jsonDecode(response);
      message = data['detail'];
      code = data['code'];
    }
    switch (statusCode) {
      case 404:
        throw ServiceNotFoundException(message);
      case 403:
      case 401:
        throw PermissionDeniedException(message);
      case 400:
        throw InvalidClientRequestException(message, code);
      default:
        throw ServerException(message, code);
    }
  }

  Future<dynamic> _executeRequest(String method, String endpoint, DateTime date, String nonce, Map<String, dynamic>? body, String? mode) async {
    Map<String, String> headers = {
      'x-mesomb-date': (date.millisecondsSinceEpoch ~/ 1000).toInt().toString(),
      'x-mesomb-nonce': nonce,
      'Content-Type': 'application/json',
      'X-MeSomb-Application': applicationKey,
      'Accept-Language': MeSomb.language,
    };
    if (mode != null) {
      headers['X-MeSomb-OperationMode'] = mode;
    }

    if (body != null) {
      body['source'] = 'MeSombDart/${MeSomb.version}';
      if (body['trxID'] != null) {
        headers['X-MeSomb-TrxID'] = body['trxID'];
      }
    }

    String authorization;
    if (body != null) {
      authorization = _getAuthorization(method, endpoint, date, nonce,
          {'content-type': 'application/json; charset=utf-8'}, body);
    } else {
      authorization = _getAuthorization(method, endpoint, date, nonce, null, null);
    }
    headers['Authorization'] = authorization;

    String url = _buildUrl(endpoint);
    var uri = Uri.parse(url);
    http.Response response;
    if (method == 'POST') {
      response = await http.post(uri, headers: headers, body: jsonEncode(body));
    } else {
      response = await http.get(uri, headers: headers);
    }

    if (response.statusCode >= 400) {
      _processClientException(response.statusCode, response.body);
    }

    return jsonDecode(response.body);
  }

  Future<TransactionResponse> makeDeposit(Map<String, dynamic> params) async {
    String endpoint = 'payment/deposit/';

    DateTime date = params['date'] ?? DateTime.now();
    String nonce = params['nonce'];

    Map<String, dynamic> body = {
      'amount': params['amount'],
      'service': params['service'],
      'receiver': params['receiver'],
      'country': params['country'] ?? 'CM',
      'currency': params['currency'] ?? 'XAF',
    };
    if (params['trxID'] != null) {
      body['trxID'] = params['trxID'];
    }
    if (params['location'] != null) {
      body['location'] = params['location'];
    }
    if (params['customer'] != null) {
      body['customer'] = params['customer'];
    }
    if (params['products'] != null) {
      body['products'] = params['products'] is List
          ? params['products']
          : [params['products']];
    }
    if (params['extra'] != null) {
      body.addAll(params['extra']);
    }

    return TransactionResponse(await _executeRequest('POST', endpoint, date, nonce, body, params['mode'] ?? 'synchronous'));
  }

  ///
  /// Collect money from a mobile account
  ///
  /// final response = await payment.makeCollect({
  /// 'amount': 100,
  /// 'service': 'MTN',
  /// 'payer': '677550203',
  /// 'nonce': RandomGenerator.nonce(),
  /// });
  Future<TransactionResponse> makeCollect(Map<String, dynamic> params) async {
    final String endpoint = 'payment/collect/';
    DateTime date = params['date'] ?? DateTime.now();
    String nonce = params['nonce'];

    Map<String, dynamic> body = {
      'amount': params['amount'],
      'service': params['service'],
      'payer': params['payer'],
      'country': params['country'] ?? 'CM',
      'currency': params['currency'] ?? 'XAF',
      'fees': params['feesIncluded'] ?? true,
      'conversion': params['conversion'] ?? false,
    };
    if (params['trxID'] != null) {
      body['trxID'] = params['trxID'];
    }
    if (params['location'] != null) {
      body['location'] = params['location'];
    }
    if (params['customer'] != null) {
      body['customer'] = params['customer'];
    }
    if (params['products'] != null) {
      body['products'] = params['products'] is List
          ? params['products']
          : [params['products']];
    }
    if (params['extra'] != null) {
      body.addAll(params['extra']);
    }

    return TransactionResponse(await _executeRequest('POST', endpoint, date, nonce, body, params['mode'] ?? 'synchronous'));
  }

  // Future<Application> updateSecurity(
  //   String field,
  //   String action ,
  //   dynamic  value,
  // ) async {
  //   const endpoint = 'payment/security/';
  //   final url = buildUrl(endpoint);
  //   DateTime date = DateTime.now();

  //   if (date == null) {
  //     date = DateTime.now();
  //   }

  //   final body = <String, dynamic>{'field': field, 'action': action};

  //   if (action != 'UNSET') {
  //     body['value'] = value;
  //   }

  //   final authorization = getAuthorization(
  //     'POST',
  //     endpoint,
  //     date,
  //     '',
  //     {'content-type': 'application/json; charset=utf-8'},
  //     body,
  //   );
  //   var uri = Uri.parse(url);
  //   final response = await http.post(
  //     uri,
  //     body: jsonEncode(body),
  //     headers: {
  //       'x-mesomb-date':(date.millisecondsSinceEpoch ~/ 1000).toInt().toString(),
  //       'x-mesomb-nonce': '',
  //       'Authorization': authorization,
  //       'Content-Type': 'application/json',
  //       'X-MeSomb-Application': applicationKey,
  //     },
  //   );
  //   if (response.statusCode >= 400) {
  //     processClientException(response.statusCode, response.body);
  //   }

  //   return Application(jsonDecode(response.body));
  // }
  Future<Application> getStatus(DateTime? date) async {
    const endpoint = 'payment/status/';

    date ??= DateTime.now();

    return Application(await _executeRequest('GET', endpoint, date, '', null, null));
  }

  Future<List<Transaction>> getTransactions(
    List<String> ids,
    DateTime? date,
  ) async {
    final endpoint = 'payment/transactions/?ids=${ids.join(',')}';

    date ??= DateTime.now();

    return (await _executeRequest('GET', endpoint, date, '', null, null))
        .map((d) => Transaction(d))
        .toList()
        .cast<Transaction>();
  }

  Future<List<Transaction>> checkTransactions(
    List<String> ids,
    DateTime? date,
  ) async {
    final endpoint = 'payment/transactions/check/?ids=${ids.join(',')}';

    date ??= DateTime.now();

    return (await _executeRequest('GET', endpoint, date, '', null, null))
        .map((d) => Transaction(d))
        .toList()
        .cast<Transaction>();
  }
}
