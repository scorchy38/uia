import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/constants.dart';

class SignInButtons extends StatelessWidget {
  const SignInButtons(
      {Key? key, required this.onSignupWithGoogle, required this.text})
      : super(key: key);

  final void Function() onSignupWithGoogle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Column(
        children: [
          const SizedBox(height: AppDefaults.margin),
          SignUpWithGoogleButton(
            onSignupWithGoogle: onSignupWithGoogle,
            text: text,
          ),
        ],
      ),
    );
  }
}

class SignUpWithGoogleButton extends StatelessWidget {
  const SignUpWithGoogleButton(
      {Key? key, required this.onSignupWithGoogle, required this.text})
      : super(key: key);

  final void Function() onSignupWithGoogle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onSignupWithGoogle,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primary,
              boxShadow: [BoxShadow(blurRadius: 1)]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.google,
                size: 18,
                color: Colors.white,
              ),
              SizedBox(width: AppDefaults.margin / 2),
              Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
