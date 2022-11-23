import 'package:flutter/material.dart';
import 'components/main_game.dart';

class FoodStylePage extends StatelessWidget {
  const FoodStylePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: SafeArea(child: FoodSuggestions()),
    );
  }
}
