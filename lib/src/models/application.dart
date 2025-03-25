import './application_balance.dart';

class Application {
  /// The key of the application
  final String key;

  /// The logo of the application
  final String? logo;

  /// The balances of the application
  late List<ApplicationBalance> balances;

  /// The countries of the application
  final List<String> countries;

  /// The description of the application
  final String description;

  /// Whether the application is live
  final String name;

  /// The security of the application
  final String? url;

  Application(Map<String, dynamic> data)
      : key = data['key'],
        logo = data['logo'],
        balances = data['balances']
            .map((d) => ApplicationBalance(d))
            .toList()
            .cast<ApplicationBalance>(),
        countries =
            data['countries'].map((country) => country).toList().cast<String>(),
        description = data['description'],
        name = data['name'],
        url = data['url'];

  double getBalance({String? country, String? service}) {
    var balances = this.balances;

    if (country != null) {
      balances = balances.where((b) => b.country == country).toList();
    }

    if (service != null) {
      balances = balances.where((b) => b.provider == service).toList();
    }

    return balances.fold(0.0, (acc, item) => acc + item.value);
  }
}
