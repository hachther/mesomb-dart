
class Product {
late String name;
late String? category;
late int? quantity;
late double? amount;

Product(Map<String, dynamic> data) {
this.name = data['name'];
this.category = data['category'];
this.quantity = data['quantity'];
this.amount = data['amount'];
}
}
