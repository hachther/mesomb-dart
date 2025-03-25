class Customer {
  /// Email of the customer
  late String? email;

  /// Phone number of the customer
  late String? phone;

  /// Town of the customer
  late String? town;

  /// Region of the customer
  late String? region;

  /// Country of the customer
  late String? country;

  /// First name of the customer
  late String? firstName;

  /// Last name of the customer
  late String lastName;

  /// Address of the customer
  late String? address;

  Customer(Map<String, dynamic> data):
    email = data['email'],
    phone = data['phone'],
    town = data['town'],
    region = data['region'],
    country = data['country'],
    firstName = data['first_name'],
    lastName = data['last_name'],
    address = data['address'];
}
