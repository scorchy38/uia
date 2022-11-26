// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:lottie/lottie.dart';
import 'package:uia/screens/passwordClash/pcGameScreen.dart';

import '../../core/constants/app_colors.dart';
import '../../services/database/room_database_helper.dart';
import 'Widgets/widget_bird.dart';
import 'Widgets/widget_gradient _button.dart';
import 'functions.dart';


class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);
  @override
  State<StartScreen> createState() => _StartScreenState();
}
final assetsAudioPlayer = AssetsAudioPlayer();

class _StartScreenState extends State<StartScreen> {

  final myBox = 'Hive.box()';

  @override
  void initState() {
    // Todo : initialize the database  <---
    initial();
    assetsAudioPlayer.open(


      Audio("assets/audios/mainapp.mp3"),
      autoStart: true,
      showNotification: false,
      playInBackground: PlayInBackground.disabledPause,

      loopMode: LoopMode.none
    );
    super.initState();
  }
WillPopScope(){
    assetsAudioPlayer.stop();
}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: background("0"),
        child: Column(
          children: [
            // Flappy bird text
            Container(
                margin: EdgeInsets.only(top: size.height * 0.25),
                child:Buttons(context), ),

          ],
        ),
      ),
    );
  }
}
TextEditingController control = TextEditingController();
OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(5),
  borderSide: BorderSide(color: Colors.grey),
  gapPadding: 10,
);
OutlineInputBorder outlineInputBorderFocused = OutlineInputBorder(
  borderRadius: BorderRadius.circular(5),
  borderSide: BorderSide(color: AppColors.primary),
  gapPadding: 10,
);
UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: AppColors.primary),
);
// three buttons
final assetsAudioPlayer1 = AssetsAudioPlayer();

Column Buttons(context){
  return Column(
    children: [

      Lottie.asset('assets/pics/fight.json', height: 200),
      InkWell(
          onTap:() async {
            assetsAudioPlayer1.open(


                Audio("assets/audios/click.mp3"),
                autoStart: true,
                showNotification: false,
                playInBackground: PlayInBackground.disabledPause,

                loopMode: LoopMode.none
            );
            String roomId = await RoomDatabaseHelper().createRoom();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PCGameScreen(gameID: roomId, userNumber: 1)));
          },
          child: Image.asset('assets/pics/start.png')),
      SizedBox(
        height: 10,
      ),
      InkWell(
        onTap:(){
          assetsAudioPlayer.stop();
          assetsAudioPlayer1.open(


              Audio("assets/audios/click.mp3"),
              autoStart: true,
              showNotification: false,
              playInBackground: PlayInBackground.disabledPause,

              loopMode: LoopMode.none
          );
          showDialog(

              context: context,builder:(context) { return AlertDialog(

            content:   Container(

              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextFormField(
                      enabled: true,
                      controller: control,
                      decoration: InputDecoration(
                        enabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorderFocused,
                        border: outlineInputBorder,
                        hintText: "Enter Room ID",
                        labelText: "Room ID",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (control.text.isEmpty) {
                          return 'This field is mandatory!';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          color: AppColors.complimentary),
                      child: InkWell(

                        onTap: () async {
                          assetsAudioPlayer1.open(


                              Audio("assets/audios/click.mp3"),
                              autoStart: true,
                              showNotification: false,
                              playInBackground: PlayInBackground.disabledPause,

                              loopMode: LoopMode.none
                          );
                          RoomDatabaseHelper().joinGame(control.text);
                          assetsAudioPlayer.stop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PCGameScreen(
                                      gameID: control.text, userNumber: 2)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 12),
                          child: Text('Join a Game',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            )
          );}

          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Image.asset('assets/pics/join.png'),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      InkWell(
        onTap:(){
          launch('https://caramel-lancer-bfd.notion.site/Password-Clash-3db38109e33349de80c0eee52d2af7c2');
        },
        child: Padding(

          padding: const EdgeInsets.only(right: 18.0),
          child: Image.asset('assets/pics/about.png'),
        ),
      ),



    ],
  );
}

class AboutUs extends StatelessWidget {
  Size size;
  AboutUs({required this.size,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(top: size.height * 0.2),
      child: GestureDetector(onTap: (){
        showDialog(context: context, builder: (context) {
          return dialog(context);
        },);
      },child: Text("About Us",style: TextStyle(fontSize: 20,fontFamily: "Magic4",color: Colors.white),)),
    );
  }
}