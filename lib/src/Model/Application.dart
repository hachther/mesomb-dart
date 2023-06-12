

import 'package:PaymentMeSomb/src/Model/ApplicationBalance.dart';

class Application {
  final String key;
  final String logo;
  late List<ApplicationBalance> balances;
  final List<String> countries;
  final String description;
  final bool is_live;
  final String name;
  final dynamic security;
  final String status;
  final String url;

  Application(Map<String, dynamic> data)
      : key = data['key'],
        logo = data['logo'],
        balances = data['balances'].map((d) => ApplicationBalance(d)).toList().cast<ApplicationBalance>(),
        countries = data['countries'].map((country) => country).toList().cast<String>(),
        description = data['description'],
        is_live = data['is_live'],
        name = data['name'],
        security = data['security'],
        status = data['status'],
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
