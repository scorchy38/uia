import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
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
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    launch("https://caramel-lancer-bfd.notion.site/Virus-Run-ee1d1ea196194a18a09e470f30330073");
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             const Wallet()));
                  },
                  child: Card(
                    elevation: 3,
                    color: AppColors.primary,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10),
                      child: Container(
                        height: 15,
                        child: Center(
                          child: Text(
                              "Know More About This Virus 🔡",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                  color: AppColors
                                      .text,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                        ),
                      ),
                    ),
                  ),
                )


              ],
            ),

        ),
          ),

    );
  }
}
