import './Customer.dart';
import './Location.dart';
import './Product.dart';

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
    this.pk = data['pk'];
    this.success = data['status'];
    this.type = data['type'];
    this.amount = data['amount'];
    this.fees = data['fees'];
    this.b_party = data['b_party'];
    this.message = data['message'];
    this.service = data['service'];
    this.reference = data['reference'];
    this.ts = data['ts'];
    this.country = data['country'];
    this.currency = data['currency'];
    this.fin_trx_id = data['fin_trx_id'];
    this.trxamount = data['trxamount'];
    if (data['location'] != null) {
      this.location = Location(data['location']);
    }
    if (data['customer'] != null) {
      this.customer = Customer(data['customer']);
    }
    if (data['products'] != null) {
      this.products =
          data['products'].map((d) => Product(d)).toList().cast<Product>();
    }
  }
}
