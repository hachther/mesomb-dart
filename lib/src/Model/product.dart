class Product {
  late String name;
  late String? category;
  late int? quantity;
  late double? amount;

  Product(Map<String, dynamic> data) {
    name = data['name'];
    category = data['category'];
    quantity = data['quantity'];
    amount = data['amount'];
  }
}
