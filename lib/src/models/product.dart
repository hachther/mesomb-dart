class Product {
  /// Unique identifier of the product
  late String id;

  /// Name of the product
  late String name;

  /// Category of the product
  late String? category;

  /// Quantity of the product
  late int? quantity;

  /// Amount of the product
  late double? amount;

  Product(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        category = data['category'],
        quantity = data['quantity'],
        amount = data['amount'] is String
            ? double.tryParse(data['amount'])
            : data['amount'];
}
