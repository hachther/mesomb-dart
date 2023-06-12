class ApplicationBalance {
  late double value;
  late String service_name;
  late String provider;
  late String? country;
  late String? currency;

  ApplicationBalance(Map<String, dynamic> data) {
    value = data['value'];
    service_name = data['service_name'];
    provider = data['provider'];
    country = data['county'];
    currency = data['currency'];
  }
}
