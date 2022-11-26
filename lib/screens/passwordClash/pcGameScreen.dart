import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uia/screens/passwordClash/analysis_sheet.dart';
import 'package:lottie/lottie.dart';
import 'package:uia/screens/passwordClash/constant.dart';
import 'package:uia/screens/passwordClash/start_screen.dart';
import 'package:uia/services/database/room_database_helper.dart';
import 'package:uia/services/database/user_database_helper.dart';

import '../../core/constants/app_colors.dart';

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
  final assetsAudioPlayer2 = AssetsAudioPlayer();

  int count = 0;

  @override
  void initState() {
    ref = FirebaseFirestore.instance.collection('passClash').doc(widget.gameID);
    opponentNumber = widget.userNumber == 1 ? 2 : 1;
    assetsAudioPlayer.pause();
    assetsAudioPlayer1.pause(); assetsAudioPlayer.stop();
    assetsAudioPlayer1.stop();
    assetsAudioPlayer2.open(


        Audio("assets/audios/waiting.mp3"),
        autoStart: true,
        showNotification: false,
        playInBackground: PlayInBackground.disabledPause,

        loopMode: LoopMode.none
    );
    // TODO: implement initState
    super.initState();
  }

  var totalScore = -1;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey =
        new GlobalKey<ScaffoldState>();

    return new Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 3,
          title: Text(
            "Room ID: ${widget.gameID}",
            style: TextStyle(color: Colors.black, fontFamily: 'Bungee'),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/pics/0.png'), fit: BoxFit.fill)),
          child: new Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Round ${currentLevel}\n FIGHT!',
              style: tstyle,
            ),
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
                        if (gameData![
                                    'score${widget.userNumber}$currentLevel'] !=
                                0 &&
                            gameData['score${opponentNumber}$currentLevel'] !=
                                0 &&
                            currentLevel < 3) currentLevel++;
                        if (currentLevel == 3) {
                          double score1 = gameData!['score11'] +
                              gameData!['score12'] +
                              gameData!['score13'];
                          double score2 = gameData!['score21'] +
                              gameData!['score22'] +
                              gameData!['score23'];
                          print(score1);
                          print(score2);
                          if (score1 > score2) {
                            totalScore = 1;
                          }
                          ;
                          if (score1 < score2) totalScore = 2;
                          if (score1 == score2) totalScore = 0;

                          if ((totalScore == 1 && widget.userNumber == 1) ||
                              (totalScore == 2 && widget.userNumber == 2) &&
                                  count == 0)
                            UserDatabaseHelper()
                                .updateScore(
                                    true,
                                    widget.gameID == 1
                                        ? gameData['uid2']
                                        : gameData['uid1'])
                                .then((value) {
                              count++;
                            });
                          else if (totalScore != 0 && count == 0)
                            UserDatabaseHelper()
                                .updateScore(
                                    false,
                                    widget.gameID == 1
                                        ? gameData['uid2']
                                        : gameData['uid1'])
                                .then((value) {
                              count++;
                            });
                        }
                        return gameData![
                                    'score${widget.userNumber}$currentLevel'] ==
                                0
                            ? Center(
                                child: Text(
                                'Your Turn, Enter a password',
                                style: tstyle,
                              ))
                            : gameData['score${opponentNumber}$currentLevel'] ==
                                    0
                                ? Center(
                                    child: Text(
                                    'Waiting for opponent\'s turn',
                                    style: tstyle,
                                  ))
                                : Center(
                                    child: Column(
                                      children: [
                                        (totalScore == 1 &&
                                                    widget.userNumber == 1) ||
                                                totalScore == 2 &&
                                                    widget.userNumber == 2
                                            ? Lottie.asset(
                                                'assets/pics/winning.json')
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 68.0),
                                                child: Lottie.asset(
                                                    'assets/pics/lose.json',
                                                    height: 200),
                                              ),
                                        Text(
                                          totalScore == 0
                                              ? 'Draw ⭐️'
                                              : totalScore == 1 &&
                                                      widget.userNumber == 1
                                                  ? 'You Won 🎉'
                                                  : totalScore == 2 &&
                                                          widget.userNumber == 2
                                                      ? 'Won'
                                                      : 'Better Luck Next Time! 🤓',
                                          style: tstyle,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: AppColors.complimentary),
                                          child: InkWell(
                                            onTap: () async {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10))),
                                                  context: context,
                                                  builder: (context) =>
                                                      AnalysisSheet(
                                                          gameDetails:
                                                              gameData));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30.0,
                                                      vertical: 12),
                                              child: Text('ANALYSIS',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontSize: 14.5,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                      }
                    })),
            // RoomDatabaseHelper().gameCompleted(widget.gameID)==1 ?  : Container(),
            // new Divider(height: 1.0),
            Container(
              height: 20,
            ),
            new Container(
              decoration: new BoxDecoration(color: Colors.yellow),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildHintComposer(),
              ),
            ),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildTextComposer(),
              ),
            ),
          ]),
        ));
  }

  TextStyle tstyle =
      TextStyle(fontSize: 22, fontFamily: 'Bungee', color: Colors.white);

  TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
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
  Widget _buildTextComposer() {
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          new Flexible(
            child: TextFormField(
              controller: _textController,
              onChanged: (String text) {
                // setState(() {
                //   _isComposing = text.length > 0;
                // });
              },
              onFieldSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                enabledBorder: outlineInputBorder,
                focusedBorder: outlineInputBorderFocused,
                border: outlineInputBorder,
                hintText: "Enter a very strong password!",
                labelText: "Password",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (_textController.text.isEmpty) {
                  return 'This field is mandatory!';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary,
              ),
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new CupertinoButton(
                child: new Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _handleSubmitted(_textController.text),
              )),
        ]),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? new BoxDecoration(
                border: new Border(top: new BorderSide(color: Colors.grey)))
            : null);
  }

  Widget _buildHintComposer() {
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          Icon(FontAwesomeIcons.lightbulb),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text('Using Special Characters tends to increase score!'),
          ),
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
          .updateGameScore(currentLevel, widget.gameID, widget.userNumber,
              score * 100, _textController.text)
          .then((value) => _textController.clear());
    } else {
      print('No Message');
    }
    setState(() {});
    _textController.clear();
  }
}
