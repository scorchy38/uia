import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uia/services/database/room_database_helper.dart';

class PCGameScreen extends StatefulWidget {
  String gameID;
  int userNumber;
  PCGameScreen({Key? key, required this.gameID, required this.userNumber})
      : super(key: key);

  @override
  State<PCGameScreen> createState() => _PCGameScreenState();
}

class _PCGameScreenState extends State<PCGameScreen> {
  DocumentReference? ref;
  int currentLevel = 1;
  int opponentNumber = 0;

  @override
  void initState() {
    ref = FirebaseFirestore.instance.collection('passClash').doc(widget.gameID);
    opponentNumber = widget.userNumber == 1 ? 2 : 1;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey =
        new GlobalKey<ScaffoldState>();

    return new Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          title: new Text("SolveCase Support"),
        ),
        body: new Column(children: <Widget>[
          new Flexible(
              child: StreamBuilder<DocumentSnapshot<Map<dynamic, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("rooms")
                      .doc(widget.gameID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'No Data...',
                      );
                    } else {
                      var gameData = snapshot.data?.data();
                      if (gameData!['score${widget.userNumber}$currentLevel'] !=
                              0 &&
                          gameData['score${opponentNumber}$currentLevel'] !=
                              0 &&
                          currentLevel < 3) currentLevel++;
                      var totalScore = -1;
                      if (currentLevel == 3) {
                        double score1 = gameData!['score11'] +
                            gameData!['score12'] +
                            gameData!['score13'];
                        double score2 = gameData!['score21'] +
                            gameData!['score22'] +
                            gameData!['score23'];
                        print(score1);
                        print(score2);
                        if (score1 > score2) totalScore = 1;
                        if (score1 < score2) totalScore = 2;
                        if (score1 == score2) totalScore = 0;
                      }
                      return gameData![
                                  'score${widget.userNumber}$currentLevel'] ==
                              0
                          ? Text('Enter a password')
                          : gameData['score${opponentNumber}$currentLevel'] == 0
                              ? Text('Waiting for opponent')
                              : Text(totalScore == 0
                                  ? 'Draw'
                                  : totalScore == 1 && widget.userNumber == 1
                                      ? 'Won'
                                      : totalScore == 2 &&
                                              widget.userNumber == 2
                                          ? 'Won'
                                          : 'Defeated');
                    }
                  })),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
          Container(
            height: 20,
          )
        ]));
  }

  TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onChanged: (String text) {
                // setState(() {
                //   _isComposing = text.length > 0;
                // });
              },
              onSubmitted: _handleSubmitted,
              decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new CupertinoButton(
                child: new Text("Send"),
                onPressed: () => _handleSubmitted(_textController.text),
              )),
        ]),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? new BoxDecoration(
                border: new Border(top: new BorderSide(color: Colors.grey)))
            : null);
  }

  void _handleSubmitted(String text) async {
    setState(() {
      _isComposing = false;
    });

    print('============================$widget.name');
    if (_textController.text != null) {
      double score =
          RoomDatabaseHelper().calculateStrength(_textController.text);
      RoomDatabaseHelper()
          .updateGameScore(
              currentLevel, widget.gameID, widget.userNumber, score * 100)
          .then((value) => _textController.clear());
    } else {
      print('No Message');
    }
    setState(() {});
    _textController.clear();
  }
}
