class Location {
  /// Location town
  late String town;

  /// Location region
  late String? region;

  /// Location country
  late String? country;

  Location(Map<String, dynamic> data):
    town = data['town'],
    region = data['region'],
    country = data['country'];
}
