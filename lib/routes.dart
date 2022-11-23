import 'package:flutter/material.dart';
import 'package:uia/screens/game_over.dart';
import 'package:uia/screens/home_page.dart';

class Routes {
  Routes._();

  static const String game_over = '/game-over';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => HP(),
    game_over: (BuildContext context) => GameOver(),
  };
}
