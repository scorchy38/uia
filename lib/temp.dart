import 'dart:async';
import 'dart:io';


import 'package:uia/screens/auth/error_page.dart';
import 'package:uia/services/authentication/authentication_service.dart';
import 'package:uia/services/database/user_database_helper.dart';
import 'package:uia/wrappers/authentication_wrapper.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/app.locator.dart';
import 'core/themes/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';

StreamingSharedPreferences? preferences;
StreamController<String> androidIdController =
    StreamController<String>.broadcast();
Stream<String> androidIdStream = androidIdController.stream;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  preferences = await StreamingSharedPreferences.instance;
  setupLocator();
  await Firebase.initializeApp();

}

class MyApp extends StatelessWidget {
  String error;
  MyApp(this.error, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // AuthenticationService().signOut();

    return MaterialApp(
      title: 'Lucky Dice',
      theme: AppThemes.light,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) =>
                  MediaQuery(
                    child: error == 'Developer'
                        ? OverlaySupport(
                      child: ErrorPage(
                          vpn: true,
                          internet: true,
                          developerMode: true,
                          root: true,
                          deviceIdCheck: true),
                    )
                        : error == 'VPN'
                        ? OverlaySupport(
                      child: ErrorPage(
                          vpn: true,
                          internet: true,
                          developerMode: false,
                          root: false,
                          deviceIdCheck: true),
                    )
                        : error == 'Internet'
                        ? OverlaySupport(
                      child: ErrorPage(
                          vpn: true,
                          internet: false,
                          developerMode: false,
                          root: false,
                          deviceIdCheck: true),
                    )
                        : OverlaySupport(child: AuthenticationWrapper()),
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: scale),
                  ),
            ),
          ],
        );
      }
    );
  }
}
