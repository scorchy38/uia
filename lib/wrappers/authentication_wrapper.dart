import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:uia/app/app.locator.dart';
import 'package:uia/screens/auth/login_page.dart';
import 'package:uia/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../models/User.dart';
import '../screens/auth/error_page.dart';
import '../screens/entrypoint/entrypoint_ui.dart';
import '../services/authentication/authentication_service.dart';

//TODO: Commented Code
class AuthenticationWrapper extends StatefulWidget {
  static const String routeName = "/authentification_wrapper";

  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  String localStatus = '';



  @override
  void initState() {
    super.initState();
    // initConnectivity();

    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // getSecurityStatus();
    getLocalAuthStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.



  Future<String> getLocalAuthStatus() async {


    localStatus = await AuthenticationService().getLocalAuthStatus();
    return localStatus;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: AuthenticationService().authStateChanges,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            return const EntryPointUI();
          } else {
            if (localStatus == 'LoggedIn') {
              return const EntryPointUI();
            } else {
              return const LoginPage();
            }
          }

        });
  }
}
