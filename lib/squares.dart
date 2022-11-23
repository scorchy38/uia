import 'package:flutter/material.dart';
class Mysquare extends StatelessWidget {
  final innercolor;
  final outercolor;
  final child;

  Mysquare({this.innercolor,this.outercolor, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child:ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: EdgeInsets.all(4),
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