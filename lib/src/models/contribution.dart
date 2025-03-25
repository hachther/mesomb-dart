import './base_transaction.dart';
import './customer.dart';
import './product.dart';

class Contribution extends ATransaction {
  /// Customer of the transaction
  late Customer? contributor;

  /// Products of the transaction
  late List<Product>? products;

  Contribution(Map<String, dynamic> data): super(data) {
    contributor = data['contributor'] != null ? Customer(data['contributor']) : null;
    products = data['products']?.map((p) => Product(p)).toList().cast<Product>();
  }
}
