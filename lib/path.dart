import 'package:flutter/material.dart';
class Mypath extends StatelessWidget {
  final innercolor;
  final outercolor;
  final child;

  Mypath({this.innercolor,this.outercolor, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child:ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(12),
          color: outercolor,
          child: Center(child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: innercolor,
              child: Center(
                 child: child,
               ),
            ),
          ),
          ),
        ),
      ),
    );
  }
}
