import 'package:flutter/material.dart';
import 'package:uia/screens/passwordClash/pcGameScreen.dart';
import 'package:uia/services/database/room_database_helper.dart';

import '../../core/constants/app_colors.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.white,
        title: Text("Clash of Passwords", style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(10)),
                color: AppColors.complimentary),
            child: InkWell(
              onTap: () async {
                String roomId = await RoomDatabaseHelper().createRoom();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PCGameScreen(gameID: roomId, userNumber: 1)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 12),
                child: Text('Create a Game',
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
          SizedBox(
            height: 40,
          ),

          Text('OR'),
          SizedBox(
            height: 40,
          ),
          Container(
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
                        RoomDatabaseHelper().joinGame(control.text);
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
        ],
      ),
    );
  }
}
