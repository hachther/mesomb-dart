class Location {
  late String town;
  late String region;
  late String country;

  Location(Map<String, dynamic> data) {
    this.town = data['town'];
    this.region = data['region'];
    this.country = data['country'];
  }
}
