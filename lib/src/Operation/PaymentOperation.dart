import 'dart:convert';

import '../Model/Application.dart';
import '../Model/Transaction.dart';
import 'package:http/http.dart' as http;

import '../Exception/InvalidClientRequestException.dart';
import '../Exception/PermissionDeniedException.dart';
import '../Exception/ServerException.dart';
import '../Exception/ServiceNotFoundException.dart';
import '../Model/TransactionResponse.dart';
import 'MeSomb.dart';
import 'Signature.dart';

class PaymentOperation {
  late String applicationKey;
  late String accessKey;
  late String secretKey;

  PaymentOperation(String applicationKey, String accessKey, String secretKey) {
    this.applicationKey = applicationKey;
    this.accessKey = accessKey;
    this.secretKey = secretKey;
  }

  String buildUrl(String endpoint) {
    String host = MeSomb.apiBase;
    String apiVersion = MeSomb.apiVersion;
    return "$host/en/api/$apiVersion/$endpoint";
  }

  String getAuthorization(String method, String endpoint, DateTime date,
      String nonce, Map<String, String> headers, Map<String, dynamic>? body) {
    String url = buildUrl(endpoint);

    Map<String, String> credentials = {
      'accessKey': this.accessKey,
      'secretKey': this.secretKey
    };

    return Signature.signRequest(
        'payment', method, url, date, nonce, credentials, headers, body);
  }

  void processClientException(int statusCode, String response) {
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

  Future<TransactionResponse> makeDeposit(Map<String, dynamic> params) async {
    String endpoint = 'payment/deposit/';
    String url = buildUrl(endpoint);
    DateTime date = params['date'] ?? DateTime.now();
    String nonce = params['nonce'];

    Map<String, dynamic> body = {
      'amount': params['amount'],
      'service': params['service'],
      'receiver': params['receiver'],
      'country': params['country'] ?? 'CM',
      'currency': params['currency'] ?? 'XAF',
      'source': 'SDKDart/${MeSomb.VERSION}',
    };
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
      body['extra'] = params['extra'];
    }

    String authorization = getAuthorization('POST', endpoint, date, nonce,
        {'content-type': 'application/json; charset=utf-8'}, body);

    Map<String, String> headers = {
      'x-mesomb-date': (date.millisecondsSinceEpoch ~/ 1000).toInt().toString(),
      'x-mesomb-nonce': nonce,
      'Authorization': authorization,
      'Content-Type': 'application/json',
      'X-MeSomb-Application': this.applicationKey
    };
    if (params['trxID'] != null) {
      headers['X-MeSomb-TrxID'] = params['trxID'];
    }

    var uri = Uri.parse(url);
    var response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode >= 400) {
      processClientException(response.statusCode, response.body);
    }

    return TransactionResponse(jsonDecode(response.body));
  }

  Future<TransactionResponse> makeCollect(Map<String, dynamic> params) async {
    final String endpoint = 'payment/collect/';
    final url = buildUrl(endpoint);
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
      'source': 'SDKDart/${MeSomb.VERSION}',
    };
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
      body['extra'] = params['extra'];
    }

    String authorization = getAuthorization('POST', endpoint, date, nonce,
        {'content-type': 'application/json; charset=utf-8'}, body);

    Map<String, String> headers = {
      'x-mesomb-date': (date.millisecondsSinceEpoch ~/ 1000).toInt().toString(),
      'x-mesomb-nonce': nonce,
      'Authorization': authorization,
      'Content-Type': 'application/json',
      'X-MeSomb-Application': applicationKey,
      'X-MeSomb-OperationMode': params['mode'] ?? 'synchronous',
    };
    if (params['trxID'] != null) {
      headers['X-MeSomb-TrxID'] = params['trxID'];
    }
    var uri = Uri.parse(url);
    var response =
        await http.post(uri, body: jsonEncode(body), headers: headers);
    if (response.statusCode >= 400) {
      processClientException(response.statusCode, response.body);
    }

    return TransactionResponse(jsonDecode(response.body));
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
    final url = buildUrl(endpoint);

    date ??= DateTime.now();

    final authorization = getAuthorization('GET', endpoint, date, '', {}, null);
    var uri = Uri.parse(url);
    final response = await http.get(
      (uri),
      headers: {
        'x-mesomb-date':
            (date.millisecondsSinceEpoch ~/ 1000).toInt().toString(),
        'x-mesomb-nonce': '',
        'Authorization': authorization,
        'X-MeSomb-Application': applicationKey,
        // 'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      processClientException(response.statusCode, response.body);
    }

    return Application(jsonDecode(response.body));
  }

  Future<List<Transaction>> getTransactions(
    List<String> ids,
    DateTime? date,
  ) async {
    final endpoint = 'payment/transactions/?ids=${ids.join(',')}';
    final url = buildUrl(endpoint);
    date ??= DateTime.now();
    final authorization = getAuthorization('GET', endpoint, date, '', {}, null);
    var uri = Uri.parse(url);
    final response = await http.get(
      (uri),
      headers: {
        'x-mesomb-date':
            (date.millisecondsSinceEpoch ~/ 1000).toInt().toString(),
        'x-mesomb-nonce': '',
        'Authorization': authorization,
        'X-MeSomb-Application': applicationKey,
      },
    );
    if (response.statusCode >= 400) {
      processClientException(response.statusCode, response.body);
    }

    return jsonDecode(response.body)
        .map((d) => Transaction(d))
        .toList()
        .cast<Transaction>();
  }
}
