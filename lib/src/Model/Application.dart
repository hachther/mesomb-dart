
class Application 
{
  late String key;

  late String? logo;

  late List<dynamic> balances;

  late List<dynamic> countries;

  late String? description;

  late bool isLive;

  late String name;

  late List<dynamic> security;

  late String status;
  late String? url;

  Application(Map<String, dynamic> data) 
  {
    this.key = data['key'];
    this.logo = data['logo'];
    this.balances = data['balances'];
    this.countries = data['countries'];
    this.description = data['description'];
    this.isLive = data['is_live'];
    this.name = data['name'];
    this.security = data['security'];
    this.status = data['status'];
    this.url = data['url'];
  }
  String getKey() {
    return this.key;
  }
  String? getLogo() {
    return this.logo;
  }
  List<dynamic> getBalances() {
    return this.balances;
  }
  List<dynamic> getCountries() {
    return this.countries;
  }
  String? getDescription() {
    return this.description;
  }


  bool isLive() {
    return this.isLive;
  }
  String getName() {
    return this.name;
  }

  List<dynamic> getSecurity() {
    return this.security;
  }
    String getStatus() {
  return this.status;
  }

    String? getUrl() 
    {
  return this.url;
  }

  dynamic getSecurityField(String field) 
  {
    return this.security.containsKey(field) ? this.security[field] : null;
  }
  
  int getBalance(String? country = null, String? service = null) 
  {
    List<dynamic> data = this.balances;
      if (country != null) {
        data = data.where((val) => val['country'] == country).toList();
    }
      if (service != null) {
        data = data.where((val) => val['provider'] == service).toList();
    }

    return data.fold(0, (acc, item) => acc + item['value']);
    
  }
}