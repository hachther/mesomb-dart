class WalletTransaction {
  late Map<String, dynamic> _data;

  /// Transaction ID.
  late int id;

  /// Transaction status.
  late String status;

  /// Transaction type.
  late String type;

  /// Transaction amount.
  late double amount;

  /// Transaction direction.
  late int direction;

  /// Transaction wallet.
  late int wallet;

  /// Transaction balance after.
  late double balanceAfter;

  /// Transaction balance after.
  late DateTime date;

  /// Transaction country.
  late String country;

  /// Transaction currency.
  late String finTrxId;

  WalletTransaction(this._data)
      : id = _data['id'],
        status = _data['status'],
        type = _data['type'],
        amount = _data['amount'].toDouble(),
        direction = _data['direction'],
        wallet = _data['wallet'],
        balanceAfter = _data['balance_after'],
        date = DateTime.parse(_data['date']),
        country = _data['country'],
        finTrxId = _data['fin_trx_id'];

  Map<String, dynamic> getData() => _data;
}