import 'package:uia/core/constants/app_colors.dart';
import 'package:uia/screens/auth/components/otp_fields.dart';
import 'package:uia/screens/auth/components/sign_in_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uia/screens/entrypoint/entrypoint_ui.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import '../../../exceptions/firebaseauth/signin_exceptions.dart';
import '../../../services/authentication/authentication_service.dart';

class LoginReferralPage extends StatefulWidget {
  LoginReferralPage({Key? key}) : super(key: key);
  @override
  State<LoginReferralPage> createState() => _LoginReferralPageState();
}

class _LoginReferralPageState extends State<LoginReferralPage> {
  @override
  void initState() {
    prints();
    super.initState();
  }

  String? token;
  prints() async {
    token = await FirebaseMessaging.instance.getToken();

    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Spacer(),
              Image.asset(
                'assets/dice/logo.png',
                height: 150,
              ),
              const SizedBox(height: 8),
              Text('Cyber Shield',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      letterSpacing: 2)),
              const SizedBox(height: 40),
              Text('Enter the Referral Code',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
              // Text('(Earn \$ 0.02 instantly!)',
              //     style: Theme.of(context).textTheme.headline6?.copyWith(
              //         color: Colors.black,
              //         fontWeight: FontWeight.normal,
              //         fontSize: 14,
              //         fontStyle: FontStyle.italic)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: buildReferralField(),
              ),
              SignInButtons(
                onSignupWithGoogle: () => signInButtonCallback(),
                text: 'Proceed to Login',
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController referralCode = TextEditingController();
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.grey),
    gapPadding: 10,
  );
  OutlineInputBorder outlineInputBorderFocused = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: AppColors.purple),
    gapPadding: 10,
  );
  UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.purple),
  );
  Widget buildReferralField() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TextFormField(
        enabled: true,
        controller: referralCode,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocused,
          border: outlineInputBorder,
          hintText: "Enter Referral Code",
          // labelText: "Referral Code",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) {
          if (referralCode.text.isEmpty) {
            return 'This field is mandatory!';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Future<void> signInButtonCallback() async {
    final AuthenticationService authService = AuthenticationService();
    bool signInStatus = false;
    String snackMessage;

    try {
      final signInFuture =
          authService.signInWithGoogle(true, referralCode.text, token!);

      signInFuture.then((value) => signInStatus = value);
      signInStatus = await showDialog(
        context: context,
        builder: (context) {
          return FutureProgressDialog(
            signInFuture,
            message: const Text("Signing in to account"),
          );
        },
      );
      if (signInStatus == true) {
        snackMessage = "Signed In Successfully";

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const EntryPointUI()));
      } else {
        throw FirebaseSignInAuthUnknownReasonFailure();
      }
    } on MessagedFirebaseAuthException catch (e) {
      snackMessage = e.message;
      if (kDebugMode) {
        print(snackMessage);
      }

      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(snackMessage),
      //   ),
      // );
    } catch (e) {
      snackMessage = e.toString();
      if (kDebugMode) {
        print(snackMessage);
      }

      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(snackMessage),
      //   ),
      // );
    }
  }
}
