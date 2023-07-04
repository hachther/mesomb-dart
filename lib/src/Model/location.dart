class Location {
  late String town;
  late String region;
  late String country;

  Location(Map<String, dynamic> data) {
    town = data['town'];
    region = data['region'];
    country = data['country'];
  }
}
