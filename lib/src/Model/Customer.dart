class Customer {
  late String? email;
  late String? phone;
  late String? town;
  late String? region;
  late String? country;

// ignore: non_constant_identifier_names
  late String? first_name;

// ignore: non_constant_identifier_names
  late String? last_name;
  late String? address;

  Customer(Map<String, dynamic> data) {
    email = data['email'];
    phone = data['phone'];
    town = data['town'];
    region = data['region'];
    country = data['country'];
    first_name = data['first_name'];
    last_name = data['last_name'];
    address = data['address'];
  }
}
