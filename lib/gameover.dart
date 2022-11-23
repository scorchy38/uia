import 'package:flutter/material.dart';
class Gameover extends StatelessWidget {
  final t;
  //final Function reset;
 // final  String result;

  Gameover({this.t});

  @override
  Widget build(BuildContext context) {
    return Center(


          child: Container(
            color: Colors.grey,
            width: double.infinity,
            child: Padding(
             padding: const EdgeInsets.only(top: 350),
              child: Column(
              children: [

                  Container(

                    child: Text( "Game Over!!!",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.yellow[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Text("Your Score is : " + t.toString(),
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                    ),

                  ),


              ],
            ),

        ),
          ),

    );
  }
}
