import './location.dart';

abstract class ATransaction {
  Map<String, dynamic> _data;

  /// Primary key of the transaction
  late String pk;

  /// Status of the transaction
  late String success;

  /// Type of the transaction
  late String type;

  /// Amount of the transaction
  late double amount;

  /// Fees of the transaction
  late double fees;

  /// B party of the transaction
  late String bParty;

  /// Message of the transaction
  late String? message;

  /// Service of the transaction
  late String service;

  /// Reference of the transaction
  late String? reference;

  /// Timestamp of the transaction
  late DateTime date;

  /// Country of the transaction
  late String country;

  /// Currency of the transaction
  late String currency;

  /// Financial transaction ID of the transaction
  late String? finTrxId;

  /// Transaction amount of the transaction
  late double? trxamount;

  /// Location of the transaction
  late Location? location;

  ATransaction(Map<String, dynamic> data)
      : _data = data,
        pk = data['pk'],
        success = data['status'],
        type = data['type'],
        amount = data['amount'],
        fees = data['fees'].toDouble(),
        bParty = data['b_party'],
        message = data['message'],
        service = data['service'],
        reference = data['reference'],
        date = DateTime.parse(data['ts']),
        country = data['country'],
        currency = data['currency'],
        finTrxId = data['fin_trx_id'],
        trxamount = data['trxamount'],
        location = data['location'] != null ? Location(data['location']) : null;

  /// Get the data of the transaction
  Map<String, dynamic> getData() {
    return _data;
  }

  /// Check if the transaction is successful
  bool isSuccess() {
    return success == 'SUCCESS';
  }

  /// Check if the transaction is pending
  bool isPending() {
    return success == 'PENDING';
  }

  /// Check if the transaction is failed
  bool isFailed() {
    return success == 'FAILED';
  }
}
