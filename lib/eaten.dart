import 'package:flutter/material.dart';
class Myfood extends StatelessWidget {
  final innercolor;
  final outercolor;
  final child;

  Myfood({this.innercolor,this.outercolor, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child:ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: EdgeInsets.all(10),
          color: outercolor,
          child: Center(child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: innercolor,
              child: Center(child: child),

            ),
          ),
          ),
        ),
      ),
    );
  }
}
