import 'package:flutter/material.dart';
import 'package:uia/Constant/assets.dart';

class Zombie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(Assets.zombieMock),
      width: 80.0,
      height: 80.0,
    );
  }
}
