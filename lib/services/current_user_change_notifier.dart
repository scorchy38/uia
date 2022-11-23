import 'package:uia/models/User.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../main.dart';
import 'authentication/authentication_service.dart';
import 'database/user_database_helper.dart';

class CurrentUserChangeNotifier extends ChangeNotifier {
  UserData? currentUserData;

  UserData? get getCurrentUserData => currentUserData;

  void setCurrentUser(bool update) async {
    bool exists = await UserDatabaseHelper().checkUserExists();
    if (update) {
      // if (!exists) {
      //   print('exists $exists');
      //   // await UserDatabaseHelper().updateUserDeviceId('');
      //   await AuthenticationService().signOutGoogle();
      //   await AuthenticationService().signOut();
      //   await AuthenticationService().setLocalAuthStatus('NotLoggedIn');
      //   runApp(OverlaySupport(child: MyApp()));
      // } else
      {
        print('exists 2 $exists');
        currentUserData = await UserDatabaseHelper().getUserDataFromId();


        print('Setting');

        notifyListeners();
      }
    }
  }
}

final currentUserChangeNotifier = CurrentUserChangeNotifier();
