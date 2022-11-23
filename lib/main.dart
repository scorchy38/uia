import 'dart:async';
import 'dart:io';


import 'package:uia/screens/auth/error_page.dart';
import 'package:uia/services/authentication/authentication_service.dart';
import 'package:uia/services/database/user_database_helper.dart';
import 'package:uia/wrappers/authentication_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/app.locator.dart';
import 'core/themes/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';

import 'models/User.dart';

StreamingSharedPreferences? preferences;
StreamController<String> androidIdController =
    StreamController<String>.broadcast();
Stream<String> androidIdStream = androidIdController.stream;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  preferences = await StreamingSharedPreferences.instance;
  await Firebase.initializeApp();
  setupLocator();
runApp(MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // AuthenticationService().signOut();

    return MaterialApp(
      title: 'Lucky Dice',
      theme: AppThemes.light,
      home: const AuthenticationWrapper(),
    );
  }
}
