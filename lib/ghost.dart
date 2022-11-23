import 'package:flutter/material.dart';
class MyGhost extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Image.asset('lib/images/ghost.png'),
    );
  }
}
