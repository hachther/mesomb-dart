import '../../mesomb.dart';
import '../models/contribution.dart';
import '../models/contribution_response.dart';
import 'base_operation.dart';

class FundraisingOperation extends AOperation {
  @override
  String service = 'fundraising';

  /// Create a new instance of [FundraisingOperation]
  ///
  /// [fundKey], [accessKey] and [secretKey] are required to make a fundraising.
  /// You can specify the [language] of the operation if not 'en' will be value by default.
  FundraisingOperation(super.fundKey, super.accessKey, super.secretKey, {super.language});

  /// Make a contribution
  ///
  /// [payer] make a contribution of [amount] through the service [service].
  /// Your can specify the [country] and [currency] of the contribution if not CM and XAF will be value by default.
  /// If your deal with a foreign currency you can set [conversion] to true.
  /// You can set [mode] to asynchronous if you want to make an asynchronous contribution.
  /// If it is an anonymous contribution you can set [anonymous] to true. if not your must set:
  ///   - [contact]: Map containing the contact information of the customer with the following attributes: phone_number, email.
  ///   - [fullName]: Map containing the full name of the customer with the following attributes: first_name, last_name.
  ///
  /// The response will be a [ContributionResponse] object.
  Future<ContributionResponse> makeContribution({
    required double amount,
    required String service,
    required String payer,
    String? nonce,
    String? trxID,
    String? country = 'CM',
    String? currency = 'XAF',
    String? mode = 'synchronous',
    bool? conversion = false,
    bool? anonymous = false,
    bool? acceptTerms = true,
    Map<String, String>? contact,
    Map<String, String>? fullName,
    Map<String, String>? location,
  }) async {
    String endpoint = 'fundraising/contribute/';

    Map<String, dynamic> body = {
      'amount': amount,
      'service': service,
      'payer': payer,
      'country': country,
      'currency': currency,
      'amount_currency': currency,
      'anonymous': anonymous,
      'accept_terms': acceptTerms,
      'conversion': conversion,
      if (trxID != null) 'trxID': trxID,
      if (location != null) 'location': location,
      if (contact != null) 'contact': contact,
      if (fullName != null) 'full_name': fullName,
    };

    return ContributionResponse(await executeRequest(
        'POST', endpoint, DateTime.now(), nonce ?? RandomGenerator.nonce(),
        body, mode));
  }

  /// Get contributions from the [ids] list.
  /// You must set [source] to specified the origin of the IDs: MESOMB if the IDs are from MeSomb otherwise EXTERNAL.
  Future<List<Contribution>> getContributions(List<String> ids, {String source = 'MESOMB'}) async {
    Map<String, String> query = {'ids': ids.join(','), 'source': source};

    final endpoint =
        'fundraising/contributions/?${Uri(queryParameters: query).query}';

    return (await executeRequest(
        'GET', endpoint, DateTime.now(), RandomGenerator.nonce(), null, null))
        .map((d) => Contribution(d))
        .toList()
        .cast<Contribution>();
  }

  /// Check contributions from the [ids] list.
  /// You must set [source] to specified the origin of the IDs: MESOMB if the IDs are from MeSomb otherwise EXTERNAL.
  Future<List<Contribution>> checkContributions(List<String> ids,
      {String source = 'MESOMB'}) async {
    Map<String, String> query = {'ids': ids.join(','), 'source': source};

    final endpoint =
        'fundraising/contributions/?${Uri(queryParameters: query).query}';

    return (await executeRequest(
        'GET', endpoint, DateTime.now(), '', null, null))
        .map((d) => Contribution(d))
        .toList()
        .cast<Contribution>();
  }
}