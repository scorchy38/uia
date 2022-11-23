import 'package:flutter/material.dart';

import 'database/user_database_helper.dart';

class PaymentMethodChangeNotifier extends ChangeNotifier {
  Map<String, dynamic>? paymentMethodData;

  Map<String, dynamic>? get getPaymentMethodData => paymentMethodData;

  void setPaymentMethod() async {
    print('Setting');
    paymentMethodData = await UserDatabaseHelper().getPaymentMethod();
    ;
    notifyListeners();
  }
}

final paymentMethodChangeNotifier = PaymentMethodChangeNotifier();
