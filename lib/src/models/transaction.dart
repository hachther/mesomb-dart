import './base_transaction.dart';
import './customer.dart';
import './product.dart';

class Transaction extends ATransaction {
  /// Customer of the transaction
  late Customer? customer;

  /// Products of the transaction
  late List<Product>? products;

  Transaction(Map<String, dynamic> data): super(data) {
    customer = data['customer'] != null ? Customer(data['customer']) : null;
    products = data['products']?.map((p) => Product(p)).toList().cast<Product>();
  }
}
