import 'package:flutter/material.dart';

import '../models/transactions.dart';
import 'database/user_database_helper.dart';

class WalletTransactionsChangeNotifier extends ChangeNotifier {
  List<Transaction>? transactions;

  List<Transaction>? get getTransactions => transactions;

  void setTransactions() async {
    print('Setting Transactions');
    transactions = await UserDatabaseHelper().getUserTransactions();
    notifyListeners();
  }
}

final walletTransactionsChangeNotifier = WalletTransactionsChangeNotifier();
