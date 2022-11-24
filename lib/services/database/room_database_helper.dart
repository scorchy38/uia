import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:password_strength/password_strength.dart';

import 'package:uia/main.dart';
import 'package:uia/models/transactions.dart' as tr;
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/User.dart';
import '../authentication/authentication_service.dart';

class RoomDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String TICKETS_KEY = "tickets";
  static const String GOLD_KEY = "coins";
  static const String DOLLARS_KEY = "cash";

  static const String DP_KEY = "profileImage";
  static const String EMAIL_KEY = "email";
  static const String REFERRAL_CODE_KEY = "referCode";
  static const String NAME_KEY = "name";
  static const String DEVICE_ID_KEY = "deviceId";

  RoomDatabaseHelper._privateConstructor();
  static final RoomDatabaseHelper _instance =
      RoomDatabaseHelper._privateConstructor();
  factory RoomDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore? get firestore {
    _firebaseFirestore ??= FirebaseFirestore.instance;
    return _firebaseFirestore;
  }

  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  math.Random _rnd = math.Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<String> createRoom() async {
    String rid = getRandomString(5);
    await firestore?.collection('rooms').doc(rid).set({
      'roomId': rid,
      'uid1': AuthenticationService().currentUser?.uid,
      'open': true,
      'score11': 0.0,
      'ans11': '',
      'ans12': '',
      'ans13': '',
      'ans21': '',
      'ans22': '',
      'ans23': '',
      'score12': 0.0,
      'score13': 0.0,
      'score21': 0.0,
      'score22': 0.0,
      'score23': 0.0,
    });
    return rid;
  }

  Future<void> updateGameScore(round, roomId, user, score, pass) async {
    await firestore?.collection('rooms').doc(roomId).update({
      'score$user$round': score,
      'ans$user$round': pass,
    });
  }

  Future<void> joinGame(roomId) async {
    await firestore?.collection('rooms').doc(roomId).update({
      'uid2': AuthenticationService().currentUser?.uid,
    });
  }

  Future<int> findWinner(roomId) async {
    await firestore?.collection('rooms').doc(roomId).get().then((value) {
      double score1 = value.data()!['score11'] +
          value.data()!['score12'] +
          value.data()!['score13'];
      double score2 = value.data()!['score21'] +
          value.data()!['score22'] +
          value.data()!['score23'];
      print(score1);
      print(score2);
      if (score1 > score2) return 1;
      if (score1 < score2) return 2;
      if (score1 == score2) return 0;
    });
    return 2;
  }

  Future<int> gameCompleted(roomId) async {
    await firestore?.collection('rooms').doc(roomId).get().then((value) {
      if (value.data()!['score11'] != 0 &&
          value.data()!['score12'] != 0 &&
          value.data()!['score13'] != 0 &&
          value.data()!['score21'] != 0 &&
          value.data()!['score22'] != 0 &&
          value.data()!['score23'] != 0) {
        return 1;
      }
    });

    return 0;
  }

  double calculateStrength(password) {
    double strength = estimatePasswordStrength(password);

    return strength;
  }
}
