import './customer.dart';
import './location.dart';
import './product.dart';

class Transaction {
  late String pk;
  late String success;
  late String type;
  late double amount;
  late double fees;

// ignore: non_constant_identifier_names
  late String b_party;
  late String message;
  late String service;
  late String? reference;
  late String ts;
  late String country;
  late String currency;

// ignore: non_constant_identifier_names
  late String? fin_trx_id;
  late double? trxamount;
  late Location? location;
  late Customer? customer;
  late List<Product>? products;

  Transaction(Map<String, dynamic> data) {
    pk = data['pk'];
    success = data['status'];
    type = data['type'];
    amount = data['amount'];
    fees = data['fees'].toDouble();
    b_party = data['b_party'];
    message = data['message'];
    service = data['service'];
    reference = data['reference'];
    ts = data['ts'];
    country = data['country'];
    currency = data['currency'];
    fin_trx_id = data['fin_trx_id'];
    trxamount = data['trxamount'];
    if (data['location'] != null) {
      location = Location(data['location']);
    }
    if (data['customer'] != null) {
      customer = Customer(data['customer']);
    }
    if (data['products'] != null) {
      products =
          data['products'].map((d) => Product(d)).toList().cast<Product>();
    }
  }
}
