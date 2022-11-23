import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPTextField extends StatelessWidget {
  const OTPTextField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.autofocus = false,
    this.decoration,
  }) : super(key: key);

  final TextEditingController controller;
  final void Function() onChanged;
  final InputDecoration? decoration;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(4),
      child: TextFormField(
        autofocus: autofocus,
        controller: controller,
        textAlign: TextAlign.center,
        onChanged: (v) => onChanged(),
        onFieldSubmitted: (v) => onChanged(),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: decoration ??
            InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                    color: controller.text.isNotEmpty
                        ? Colors.black
                        : Colors.grey),
              ),
              hintText: '0',
            ),
      ),
    ));
  }
}
