
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Signature {
  static String signRequest(String service, String method, String url,
      DateTime date, String nonce, Map<String, String> credentials,
      [Map<String, String>? headers, Map<String, dynamic>? body]) {
    var algorithm = 'HMAC-SHA1';
    var parse = Uri.parse(url);
    var canonicalQuery = parse.hasQuery ? parse.query : '';

    var timestamp = (date.millisecondsSinceEpoch ~/ 1000).toInt();

    if (headers == null) 
    {
      headers = {};
    }
    headers['host'] = parse.scheme +'://' +parse.host +(parse.hasPort ? ':' + parse.port.toString() : '');
    headers['x-mesomb-date'] = timestamp.toString();
    headers['x-mesomb-nonce'] = nonce;
    var sortedKeys = headers.keys.toList()..sort();
    var canonicalHeaders =
        sortedKeys.map((k) => '${k.toLowerCase()}:${headers?[k]}').join('\n');
        print(canonicalHeaders);

    if (body == null) 
    {
      body = {};
    }
    var bodyJson = jsonEncode(body);
    var payloadHash = sha1.convert(utf8.encode(bodyJson)).toString();

    var signedHeaders = sortedKeys.join(';');

    var path = parse.pathSegments
        .map((segment) => Uri.encodeComponent(segment))
        .join('/');
    var canonicalRequest =
        '$method\n/$path\n$canonicalQuery\n$canonicalHeaders\n$signedHeaders\n$payloadHash';

    var scope =
        '${date.year}${date.month}${date.day}/$service/mesomb_request';
    var stringToSign =
        '$algorithm\n$timestamp\n$scope\n${sha1.convert(utf8.encode(canonicalRequest)).toString()}';

    var signature = Hmac(sha1, utf8.encode(credentials['secretKey']!))
        .convert(utf8.encode(stringToSign))
        .toString();
    var accessKey = credentials['accessKey'];

    return '$algorithm Credential=$accessKey/$scope, SignedHeaders=$signedHeaders, Signature=$signature';
  }
}
