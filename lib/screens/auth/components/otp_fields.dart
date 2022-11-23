import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import 'otp_text_field.dart';

class OTPFields extends StatefulWidget {
  const OTPFields({
    Key? key,
  }) : super(key: key);

  @override
  State<OTPFields> createState() => _OTPFieldsState();
}
late TextEditingController controller1;
late TextEditingController controller2;
late TextEditingController controller3;
late TextEditingController controller4;

class _OTPFieldsState extends State<OTPFields> {
  /// Increase the controller if you needs more field, but beware that
  /// you need to dispose them as well, otherwise memory leak will happen


  /* <----  -----> */
  void _shiftToNextField(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      FocusScope.of(context).nextFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    controller4 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
  }

  final InputDecoration _decoration = InputDecoration(
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.25))),
    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide()),
    border: const UnderlineInputBorder(borderSide: BorderSide()),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              OTPTextField(
                onChanged: () => _shiftToNextField(controller1),
                controller: controller1,
                decoration: _decoration,
                autofocus: true,
              ),
              OTPTextField(
                onChanged: () => _shiftToNextField(controller2),
                controller: controller2,
                decoration: _decoration,
              ),
              OTPTextField(
                onChanged: () => _shiftToNextField(controller3),
                controller: controller3,
                decoration: _decoration,
              ),
              OTPTextField(
                onChanged: () => _shiftToNextField(controller4),
                controller: controller4,
                decoration: _decoration,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
