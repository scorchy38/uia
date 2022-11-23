import 'package:uia/services/authentication/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../main.dart';
import '../models/User.dart';
import 'database/user_database_helper.dart';

class GoldChangeNotifier extends ChangeNotifier {
  int? goldValue;

  int? get getGoldValue => goldValue;

  void setMethod() async {
    bool exists = await UserDatabaseHelper().checkUserExists();

    if (!exists) {
      // await UserDatabaseHelper().updateUserDeviceId('');
      await AuthenticationService().signOutGoogle();
      await AuthenticationService().signOut();
      await AuthenticationService().setLocalAuthStatus('NotLoggedIn');
      runApp(OverlaySupport(child: MyApp()));
      notifyListeners();
    } else {
      print('Setting');
      UserData? user = await UserDatabaseHelper().getUserDataFromId();
      goldValue = user!.gold;

      notifyListeners();
    }
  }
}

final goldChangeNotifier = GoldChangeNotifier();
