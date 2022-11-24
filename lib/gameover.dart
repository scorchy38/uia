import 'package:flutter/material.dart';
import 'package:uia/core/constants/app_colors.dart';
class Gameover extends StatelessWidget {
  final t;
  //final Function reset;
 // final  String result;

  Gameover({this.t});

  @override
  Widget build(BuildContext context) {
    return Center(


          child: Container(
            color: AppColors.primary,
            width: double.infinity,
            child: Padding(
             padding: const EdgeInsets.only(top: 100),
              child: Column(
              children: [
                  Image.asset('assets/images/trojan.gif', height: 250,),
                  Container(

                    child: Text( "Game Over!!!",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
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
