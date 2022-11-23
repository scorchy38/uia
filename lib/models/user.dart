import 'package:cloud_firestore/cloud_firestore.dart';

import 'Model.dart';

class UserData extends Model {
  static const String USERS_COLLECTION_NAME = "users";
  static const String TICKETS_KEY = "tickets";
  static const String GOLD_KEY = "coins";
  static const String DOLLARS_KEY = "cash";

  static const String DP_KEY = "profileImage";
  static const String EMAIL_KEY = "email";
  static const String AGE_KEY = "age";
  static const String REFERRAL_CODE_KEY = "referCode";
  static const String NAME_KEY = "name";
  static const String DEVICE_ID_KEY = "deviceId";

  String email;
  String name;
  int tickets;
  int gold;
  double dollars;
  String rc;
  String deviceId;
  int adSeen;
  int age;
  bool rated;
  bool activated;
  Timestamp createdTime;
  String token;
  String uid;
  int userRank;
  String dpUrl;

  UserData({
    required String? id,
    required this.name,
    required this.email,
    required this.tickets,
    required this.gold,
    required this.dollars,
    required this.rc,
    required this.deviceId,
    required this.adSeen,
    required this.age,
    required this.rated,
    required this.activated,
    required this.createdTime,
    required this.token,
    required this.uid,
    required this.userRank,
    required this.dpUrl,
  }) : super(id!);

  factory UserData.fromMap(Map<String, dynamic>? map,
      {required String? id, String? devID}) {
    // if (map == null)
    //   return UserData(
    //       activated: true,
    //       name: '',
    //       email: '',
    //       tickets: 0,
    //       gold: 0,
    //       dollars: 0,
    //       rc: '',
    //       deviceId: devID!,
    //       adSeen: 0,
    //       age: 0,
    //       rated: false,
    //       createdTime: Timestamp.now(),
    //       token: '',
    //       dpUrl: '',
    //       uid: '',
    //       userRank: 0,
    //       // update: false,
    //       id: '');
    return UserData(
      id: id,
      email: map![EMAIL_KEY],
      name: map[NAME_KEY],
      tickets: map[TICKETS_KEY],
      gold: map[GOLD_KEY],
      dollars: map[DOLLARS_KEY].runtimeType == 'double'
          ? map[DOLLARS_KEY]
          : map[DOLLARS_KEY] * 1.0,
      rc: map[REFERRAL_CODE_KEY],
      age: map['age'],
      deviceId: map['deviceId'],
      userRank: map['userRank'],
      rated: map['rated'],
      uid: map['uid'],
      dpUrl: map['profileImage'],
      createdTime: map['createdTime'],
      activated: map['activated'],
      token: map['fcm_token'],
      adSeen: map['adSeen'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      NAME_KEY: name,
      EMAIL_KEY: email,
      TICKETS_KEY: tickets,
      GOLD_KEY: gold,
      DOLLARS_KEY: dollars,
      REFERRAL_CODE_KEY: rc,
      'age': age,
      'deviceId': deviceId,
      'userRank': userRank,
      'rated': rated,
      'profileImage': dpUrl,
      'uid': uid,
      'createdTime': createdTime,
      'activated': activated,
      'fcm_token': token,
      'adSeen': adSeen,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    map[EMAIL_KEY] = email;
    map[NAME_KEY] = name;
    map[TICKETS_KEY] = tickets;
    map[GOLD_KEY] = gold;
    map[DOLLARS_KEY] = dollars;
    map[REFERRAL_CODE_KEY] = rc;
    map['age'] = age;
    map['deviceId'] = deviceId;
    map['userRank'] = userRank;
    map['rated'] = rated;
    map['uid'] = uid;
    map['profileImage'] = dpUrl;
    map['createdTime'] = createdTime;
    map['activated'] = activated;
    map['token'] = token;
    map['adSeen'] = adSeen;

    return map;
  }
}
