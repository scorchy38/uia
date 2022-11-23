import 'package:cloud_firestore/cloud_firestore.dart';

import 'Model.dart';

class Transaction extends Model {
  static const String USERTRANSACTIONS_COLLECTION_NAME = "userTransactions";
  static const String AMOUNT_KEY = "amount";
  static const String DATE_KEY = "date";
  static const String ORDER_KEY = "orderId";
  static const String STATE_KEY = "state";

  static const String TIME_KEY = "time";

  int amount;
  int date;
  String orderId;
  String state;
  Timestamp time;

  Transaction({
    required String? id,
    required this.amount,
    required this.date,
    required this.orderId,
    required this.state,
    required this.time,
  }) : super(id!);

  factory Transaction.fromMap(Map<String, dynamic>? map,
      {required String? id}) {
    return Transaction(
      id: id,
      amount: map![AMOUNT_KEY],
      date: map[DATE_KEY],
      orderId: map[ORDER_KEY],
      state: map[STATE_KEY],
      time: map[TIME_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AMOUNT_KEY: amount,
      DATE_KEY: date,
      ORDER_KEY: orderId,
      STATE_KEY: state,
      TIME_KEY: time,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    map[AMOUNT_KEY] = amount;
    map[DATE_KEY] = date;
    map[ORDER_KEY] = orderId;
    map[STATE_KEY] = state;
    map[TIME_KEY] = time;

    return map;
  }
}
