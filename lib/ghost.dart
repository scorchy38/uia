import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyGhost extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Transform(
          transform: Matrix4.rotationY(math.pi),
          alignment: Alignment.center,
          child: Image.asset('lib/images/trojan.png', )),
    );
  }
}
