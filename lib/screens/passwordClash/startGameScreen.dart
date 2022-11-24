import 'package:flutter/material.dart';
import 'package:uia/screens/passwordClash/pcGameScreen.dart';
import 'package:uia/services/database/room_database_helper.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  TextEditingController control = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Create a game'),
              ),
            ),
            onTap: () async {
              String roomId = await RoomDatabaseHelper().createRoom();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PCGameScreen(gameID: roomId, userNumber: 1)));
            },
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    controller: control,
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                          color: Colors.grey, child: Text('Join a game')),
                    ),
                    onTap: () async {
                      RoomDatabaseHelper().joinGame(control.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PCGameScreen(
                                  gameID: control.text, userNumber: 2)));
                    },
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
