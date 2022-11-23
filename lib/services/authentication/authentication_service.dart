import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import '../../exceptions/firebaseauth/signin_exceptions.dart';
import '../../main.dart';
import '../current_user_change_notifier.dart';
import '../database/user_database_helper.dart';

class AuthenticationService {
  static const String USER_NOT_FOUND_EXCEPTION_CODE = "user-not-found";
  static const String WRONG_PASSWORD_EXCEPTION_CODE = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE_EXCEPTION_CODE =
      "email-already-in-use";
  static const String OPERATION_NOT_ALLOWED_EXCEPTION_CODE =
      "operation-not-allowed";
  static const String WEAK_PASSWORD_EXCEPTION_CODE = "weak-password";
  static const String USER_MISMATCH_EXCEPTION_CODE = "user-mismatch";
  static const String INVALID_CREDENTIALS_EXCEPTION_CODE = "invalid-credential";
  static const String INVALID_EMAIL_EXCEPTION_CODE = "invalid-email";
  static const String USER_DISABLED_EXCEPTION_CODE = "user-disabled";
  static const String INVALID_VERIFICATION_CODE_EXCEPTION_CODE =
      "invalid-verification-code";
  static const String INVALID_VERIFICATION_ID_EXCEPTION_CODE =
      "invalid-verification-id";
  static const String REQUIRES_RECENT_LOGIN_EXCEPTION_CODE =
      "requires-recent-login";

  FirebaseAuth? _firebaseAuth;

  AuthenticationService._privateConstructor();
  static final AuthenticationService _instance =
      AuthenticationService._privateConstructor();

  FirebaseAuth? get firebaseAuth {
    _firebaseAuth ??= FirebaseAuth.instance;
    return _firebaseAuth;
  }

  factory AuthenticationService() {
    return _instance;
  }

  Stream<User?>? get authStateChanges => firebaseAuth?.authStateChanges();

  Stream<User?>? get userChanges => firebaseAuth?.userChanges();

  Future<void> deleteUserAccount() async {
    await currentUser?.delete();
    await signOut();
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool perform = false;

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }

  bool valid = false;
  String? _token;
  FirebaseMessaging? _firebaseMessaging;

  String referrerId = '';

  Future<bool> signInWithGoogle(bool referred, String rc, String token) async {
    try {
      referred
          ? await FirebaseFirestore.instance
              .collection('users')
              .get()
              .then((value) => value.docs.forEach((element) {
                    if (element['referCode'] == rc) {
                      valid = true;
                      referrerId = element['email'];
                    }
                  }))
          : true;
      if (valid || !referred) {
        if (kDebugMode) {
          print(googleSignIn);
        }

        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        if (kDebugMode) {
          print(googleSignIn);
        }
        final GoogleSignInAuthentication? googleSignInAuthentication =
            await googleSignInAccount?.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication?.accessToken,
          idToken: googleSignInAuthentication?.idToken,
        );

        final UserCredential? authResult =
            await firebaseAuth?.signInWithCredential(credential);
        final User? user = authResult?.user;

        if (user != null) {
          assert(!user.isAnonymous);

          final User? currentUser = firebaseAuth?.currentUser;
          assert(user.uid == currentUser?.uid);

          await FirebaseFirestore.instance
              .collection('users')
              .get()
              .then((value) => value.docs.forEach((element) {
                    if (element.id == user.email) {
                      perform = true;
                    }
                  }));
          if (perform == false) {
            print('running2');


            await UserDatabaseHelper().createNewUser(user.uid, user.email,
                user.displayName, user.photoURL, "dId", token);
            referred
                ? referrerId != ''
                    ? await UserDatabaseHelper().addReferredBy(referrerId)
                    : null
                : null;
            // referred ? await UserDatabaseHelper().updateDollars(0.02) : null;
            referred ? await UserDatabaseHelper().cloudReferReward(rc) : null;

            // referred
            //     ? await UserDatabaseHelper()
            //         .updateDollarsForOtherUser(0.01, referrerId)
            //     : null;

            referred
                ? Fluttertoast.showToast(
                    msg: "Reward Granted! Check your wallet!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16.0)
                : null;
          } else {
            print('running');

            await UserDatabaseHelper().updateUserDeviceId("currentDeviceId"!);
          }

          return true;
        } else {
          print('User not found');
          return false;
        }
      } else {
        Fluttertoast.showToast(
            msg: "Some Error!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16.0);
        return false;
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case INVALID_EMAIL_EXCEPTION_CODE:
          throw FirebaseSignInAuthInvalidEmailException();

        case USER_DISABLED_EXCEPTION_CODE:
          throw FirebaseSignInAuthUserDisabledException();

        case USER_NOT_FOUND_EXCEPTION_CODE:
          throw FirebaseSignInAuthUserNotFoundException();

        case WRONG_PASSWORD_EXCEPTION_CODE:
          throw FirebaseSignInAuthWrongPasswordException();

        default:
          throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }



  Future<String> getLocalAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? status = prefs.getString('status');
    if (status == null) return 'NotLoggedIn';

    return status;
  }

  Future<bool> setLocalAuthStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('status', status);
    return true;
  }

  Future<void> signOut() async {
    await firebaseAuth?.signOut();
  }

  User? get currentUser {
    return firebaseAuth?.currentUser;
  }

  Future<void> updateCurrentUserDisplayName(String updatedDisplayName) async {
    await currentUser?.updateProfile(displayName: updatedDisplayName);
  }
}
