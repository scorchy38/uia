import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uia/screens/entrypoint/entrypoint_ui.dart';

import '../../core/constants/constants.dart';

class RegisterSuccessfullPage extends StatelessWidget {
  const RegisterSuccessfullPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Yeay! Ready to eat\neverything?',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    /// This svg image is 50 pixels on the left side, so it looks
                    /// misaligned on the ui, that's why we added 50 pixels here.
                    const SizedBox(width: 50),
                    Expanded(
                        child:
                            SvgPicture.asset(AppIllustrations.illustration3)),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EntryPointUI(),
                        ));
                  },
                  child: const Text('Find food near you'),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
