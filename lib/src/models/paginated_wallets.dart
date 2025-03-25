import 'wallet.dart';

import 'base_paginated.dart';

class PaginatedWallets extends APaginated {
  late List<Wallet> results;

  PaginatedWallets(Map<String, dynamic> data) : super(data) {
    results = List<Wallet>.from(data['results'].map((x) => Wallet(x)));
  }
}