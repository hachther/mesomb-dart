import 'dart:convert';
import 'package:http/http.dart' as http;

import '../exceptions/invalid_client_request_exception.dart';
import '../exceptions/permission_denied_exception.dart';
import '../exceptions/server_exception.dart';
import '../exceptions/service_not_found_exception.dart';
import '../mesomb.dart';
import '../signature.dart';

abstract class AOperation {
  late String target;
  late String accessKey;
  late String secretKey;
  late String language;

  String service = '';

  AOperation(this.target, this.accessKey, this.secretKey, {this.language = 'en'});

  String buildUrl(String endpoint) {
    String host = MeSomb.apiBase;
    String apiVersion = MeSomb.apiVersion;
    return "$host/api/$apiVersion/$endpoint";
  }

  String _getAuthorization(String method, String endpoint, DateTime date,
      String nonce, Map<String, String>? headers, Map<String, dynamic>? body) {
    String url = buildUrl(endpoint);

    Map<String, String> credentials = {
      'accessKey': accessKey,
      'secretKey': secretKey
    };

    return Signature.signRequest(
        'payment', method, url, date, nonce, credentials, headers, body);
  }

  void processClientException(int statusCode, String response) {
    String? code;
    String message = response;
    print(response);
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

  Future<dynamic> executeRequest(String method, String endpoint, DateTime date, String nonce, Map<String, dynamic>? body, String? mode) async {
    Map<String, String> headers = {
      'x-mesomb-date': (date.millisecondsSinceEpoch ~/ 1000).toInt().toString(),
      'x-mesomb-nonce': nonce,
      'Content-Type': 'application/json',
      if (service == 'payment')'X-MeSomb-Application': target,
      if (service == 'fundraising')'X-MeSomb-Fund': target,
      if (service == 'wallet')'X-MeSomb-Provider': target,
      'X-MeSomb-Source': 'MeSombDart/${MeSomb.version}',
      'Accept-Language': language,
    };
    if (mode != null) {
      headers['X-MeSomb-OperationMode'] = mode;
    }

    if (body != null) {
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

    String url = buildUrl(endpoint);
    var uri = Uri.parse(url);
    http.Response response;
    if (method != 'GET') {
      var func = {
        'POST': http.post,
        // 'GET': http.get,
        'PUT': http.put,
        'PATCH': http.patch,
        'DELETE': http.delete,
      }[method];
      response = await func!(uri, headers: headers, body: jsonEncode(body));
    } else {
      response = await http.get(uri, headers: headers);
    }

    if (response.statusCode >= 400) {
      processClientException(response.statusCode, response.body);
    }

    return jsonDecode(response.body);
  }
}