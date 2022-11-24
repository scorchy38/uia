import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:uia/main.dart';
import 'package:uia/models/transactions.dart' as tr;
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/User.dart';
import '../authentication/authentication_service.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String TICKETS_KEY = "tickets";
  static const String GOLD_KEY = "coins";
  static const String DOLLARS_KEY = "cash";

  static const String DP_KEY = "profileImage";
  static const String EMAIL_KEY = "email";
  static const String REFERRAL_CODE_KEY = "referCode";
  static const String NAME_KEY = "name";
  static const String DEVICE_ID_KEY = "deviceId";

  UserDatabaseHelper._privateConstructor();
  static final UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
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

  Future<void> createNewUser(
    String uid,
    String? email,
    String? name,
    String? url,
    String? deviceId,
    String? token,
  ) async {
    await firestore?.collection(USERS_COLLECTION_NAME).doc(email).set({
      DP_KEY: url,
      NAME_KEY: name,
      EMAIL_KEY: email,
      TICKETS_KEY: 90,
      GOLD_KEY: 0,
      REFERRAL_CODE_KEY: getRandomString(4),
      DOLLARS_KEY: 0.001,
      DEVICE_ID_KEY: deviceId,
      "adSeen": 0,
      "age": 0,
      "activated": true,
      "rated": false,
      "referredBy": null,
      "createdTime": DateTime.now(),
      "fcm_token": token,
      "uid": uid,
      "userRank": 0,
      "score": 0,
      // 'update': false,
    });
    log("New User Created");
  }

  Future<void> addPaymentMethod(
    String? country,
    String? paymentMethod,
    String? accountNo,
    String? Name,
  ) async {
    String? email = AuthenticationService().currentUser?.email;
    await firestore?.collection('userTransactions').doc(email).set({
      'paymentMethod': {
        'country': country,
        'details': {
          'payeeAccountNo':
              paymentMethod != 'PayPal' ? int.parse(accountNo!) : accountNo,
          'payeeName': Name
        },
        'id': paymentMethod
      },
    });
  }

  Future<UserData>? getUserDataFromId() async {
    UserData user;

    String? email = AuthenticationService().currentUser?.email;

    if (email == null) {
      return UserData(
          activated: true,
          name: 'Hello',
          email: '',
          tickets: 0,
          gold: 0,
          dollars: 0,
          rc: '',
          deviceId: "currentDeviceID",
          adSeen: 0,
          age: 0,
          rated: false,
          createdTime: Timestamp.now(),
          token: '',
          dpUrl: '',
          uid: '',
          userRank: 0,
          // update: false,
          id: '');
    }
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(email).get();
    print(doc!.exists);
    if (!doc.exists)
      return UserData(
          activated: true,
          name: '',
          email: '',
          tickets: 0,
          gold: 0,
          dollars: 0,
          rc: '',
          deviceId: "currentDeviceID",
          adSeen: 0,
          age: 0,
          rated: false,
          createdTime: Timestamp.now(),
          token: '',
          dpUrl: '',
          uid: '',
          userRank: 0,
          // update: false,
          id: '');
    user = UserData.fromMap(doc?.data(), id: doc?.id);

    return user;
  }

  Future<bool> checkUserExists() async {
    String? email = AuthenticationService().currentUser?.email;

    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(email).get();

    return doc!.exists;
  }

  Future<Map<String, dynamic>?>? getPaymentMethod() async {
    Map<String, dynamic>? paymentMethod;
    String? email = AuthenticationService().currentUser?.email;
    final doc =
        await firestore?.collection('userTransactions').doc(email).get();

    paymentMethod = doc?.data();

    return paymentMethod;
  }

  Future<bool> updateScore(bool win, String opponentsID) async {
    String? email = AuthenticationService().currentUser?.email;
    final doc = await firestore?.collection('users').doc(email);
    doc?.get().then((value) {
      int score = value.data()!['score'];
      print(score);
      doc.update({'score': win ? score + 50 : score - 10});
    });

    final doc2 = await firestore
        ?.collection('users')
        .where('uid', isEqualTo: opponentsID);
    doc2?.get().then((value) {
      int score = value.docs[0].data()!['score'];
      print(score);
      value.docs[0].reference.update({'score': win ? score - 10 : score + 50});
    });

    return true;
  }

  Future<List<tr.Transaction>>? getUserTransactions() async {
    List<tr.Transaction> transactions = [];

    String? email = AuthenticationService().currentUser?.email;
    print(email);

    await firestore
        ?.collection("userTransactions")
        .doc(email)
        .collection("details")
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        print(doc.data());
        tr.Transaction temp = tr.Transaction.fromMap(
          doc.data(),
          id: doc.id,
        );
        transactions.add(temp);
        print(transactions);
      });
    });
    transactions.sort((a, b) => b.time.compareTo(a.time));
    print(transactions);

    // user = UserData.fromMap(doc?.data(), id: doc?.id);

    return transactions;
  }

  // void uploadTransactions() async {
  //   List<tr.Transaction> transactions = [
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGei',
  //         amount: 5.001,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'approved',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGen',
  //         amount: 8.2,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'error',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGeo',
  //         amount: 9.3,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'pending',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGep',
  //         amount: 11.99,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'paid',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGeq',
  //         amount: 7.2,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'error',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGer',
  //         amount: 22.2,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'approved',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGes',
  //         amount: 11.2,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'pending',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGet',
  //         amount: 6.8,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'paid',
  //         time: Timestamp(1656948463, 763000000)),
  //     tr.Transaction(
  //         id: 'BTELJ27vhwjmD7WprGeu',
  //         amount: 3.2,
  //         date: 1656948404062,
  //         orderId: 'BTELJ27vhwjmD7WprGem',
  //         state: 'paid',
  //         time: Timestamp(1656948463, 763000000)),
  //   ];
  //
  //   String? email = AuthenticationService().currentUser?.email;
  //   for (int i = 0; i < transactions.length; i++) {
  //     await firestore
  //         ?.collection("userTransactions")
  //         .doc(email)
  //         .collection("details")
  //         .doc(transactions[i].id)
  //       'amount': transactions[i].amount,
  //       'date': transactions[i].date,
  //       "orderId": transactions[i].orderId,
  //       'state': transactions[i].state,
  //       'time': transactions[i].time,
  //     });
  //   }
  // }

  Future<List<Map>> getUsers() async {
    List<Map> val = [];
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('coins', descending: true)
        .limit(30)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        val.add(element.data());
      });
    });
    return val;
  }

  useTicket() async {
    String? uid = AuthenticationService().currentUser?.email;
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    UserData user = UserData.fromMap(doc?.data(), id: doc?.id);
    int ticks = user.tickets;
    ticks = ticks - 1;

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).update({
      TICKETS_KEY: ticks,
    });
  }

  cloudTicket(int val) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'surgeTikt',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );
    final result = callable.call({"increase": val});
  }

  cloudAdSurge() async {
    HttpsCallable callable2 = FirebaseFunctions.instance.httpsCallable(
      'surgeAdCunt',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );
    final result2 = callable2.call();
  }

  cloudGoldSurge(int val) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'surgeCoinVal',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );
    final result = callable.call({"increase": val});
  }

  cloudReferReward(String referCode) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'referReward',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );
    final result = callable.call({"referCode": referCode});
  }

  cloudWithdraw(double amount) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'requestPayout',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );
    final result = callable.call({"amount": amount});
  }

  cloudRateUs() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'rateUsReward',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );
    final result = callable.call();
  }

  updateGold(int amnt) async {
    String? uid = AuthenticationService().currentUser?.email;
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    UserData user = UserData.fromMap(doc?.data(), id: doc?.id);
    int goldValue = user.gold;
    goldValue = goldValue + amnt;

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).update({
      GOLD_KEY: goldValue,
    });
  }

  updateAdSeen() async {
    String? uid = AuthenticationService().currentUser?.email;
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    UserData user = UserData.fromMap(doc?.data(), id: doc?.id);
    int adSeen = user.adSeen;
    adSeen = adSeen + 1;

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).update({
      'adSeen': adSeen,
    });
  }

  updateDollars(double amnt) async {
    String? uid = AuthenticationService().currentUser?.email;
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    UserData user = UserData.fromMap(doc?.data(), id: doc?.id);
    double dollarsValue = user.dollars;
    dollarsValue = dollarsValue + amnt;

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).update({
      DOLLARS_KEY: dollarsValue,
    });
  }

  updateDollarsForOtherUser(double amnt, String id) async {
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(id).get();
    UserData user = UserData.fromMap(doc?.data(), id: doc?.id);
    double dollarsValue = user.dollars;
    dollarsValue = dollarsValue + amnt;

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(id).update({
      DOLLARS_KEY: dollarsValue,
    });
  }

  addReferredBy(String id) async {
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(id).get();
    UserData user = UserData.fromMap(doc?.data(), id: doc?.id);
    String? uid = AuthenticationService().currentUser?.email;

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).update({
      'referredBy': user.email,
    });
  }

  updateTickets(int amnt) async {
    String? uid = AuthenticationService().currentUser?.email;
    final doc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    UserData user = UserData.fromMap(doc?.data(), id: doc?.id);
    int ticks = user.tickets;
    ticks = ticks + amnt;

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).update({
      TICKETS_KEY: ticks,
    });
  }

  updateUserDeviceId(String deviceId) async {
    String? uid = AuthenticationService().currentUser?.email;
    // final doc =
    //     await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    // UserData user = UserData.fromMap(doc?.data(), id: doc?.id);

    final newDoc =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).update({
      DEVICE_ID_KEY: deviceId,
    });
  }

  updateUserData(String name, String age) async {
    String? email = AuthenticationService().currentUser?.email;
    final doc = await firestore
        ?.collection(USERS_COLLECTION_NAME)
        .doc(email)
        .update({'age': int.parse(age), UserData.NAME_KEY: name});
    // await refreshUserData();
  }

  Future<String> getCurrentUserEmail() async {
    String? email = AuthenticationService().currentUser?.email;
    if (email == null) {
      String? uid = AuthenticationService().currentUser?.email;
      final doc =
          await firestore?.collection(USERS_COLLECTION_NAME).doc(email).get();
      final mail = doc?.data()!['email'];
      return mail;
    }

    return email;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? get currentUserDataStream {
    String? uid = AuthenticationService().currentUser?.email;
    return firestore
        ?.collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  String getPathForCurrentUserDisplayPicture() {
    final String? currentUserUid = AuthenticationService().currentUser?.email;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String? uid = AuthenticationService().currentUser?.email;
    final userDocSnapshot =
        firestore?.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot?.update(
      {DP_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String? uid = AuthenticationService().currentUser?.email;
    final userDocSnapshot =
        firestore?.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot?.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> getDisplayPictureForCurrentUser() async {
    String? uid = AuthenticationService().currentUser?.email;
    final userDocSnapshot =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot?.data()![DP_KEY];
  }

  Future<String> get displayPictureForCurrentUser async {
    String? uid = AuthenticationService().currentUser?.email;
    final userDocSnapshot =
        await firestore?.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot?.data()![DP_KEY];
  }
}
