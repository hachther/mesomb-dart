import 'base_paginated.dart';
import 'wallet_transaction.dart';

class PaginatedTransactions extends APaginated {
  late List<WalletTransaction> results;

  PaginatedTransactions(Map<String, dynamic> data) : super(data) {
    results = List<WalletTransaction>.from(data['results'].map((x) => WalletTransaction(x)));
  }
}