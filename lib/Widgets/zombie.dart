import 'package:flutter/material.dart';
import 'package:uia/Constant/assets.dart';

class Zombie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Center(
                child: Text(
              'I want your OTP 👻',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            )),
            height: 30,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: Image.asset(Assets.zombieMock),
            width: 80.0,
            height: 80.0,
          ),
        ],
      ),
    );
  }
}
