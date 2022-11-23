// import 'dart:html';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uia/services/gold_change_notifier.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';
import 'cell.dart';
import 'cell_widget.dart';

class FoodSuggestions extends StatefulWidget {
  const FoodSuggestions({
    Key? key,
  }) : super(key: key);

  @override
  State<FoodSuggestions> createState() => _FoodSuggestionsState();
}

class _FoodSuggestionsState extends State<FoodSuggestions>
    with SingleTickerProviderStateMixin {

  int score = 0;
  final imagesMap = [
    {'image': 'assets/images/goodLink.png', 'isMine': false},
    {'image': 'assets/images/badLink.png', 'isMine': true},
    {'image': 'assets/images/fairOrder.png', 'isMine': false},
    {'image': 'assets/images/freeOrder.png', 'isMine': true},
    {'image': 'assets/images/playDownload.png', 'isMine': false},
    {'image': 'assets/images/malwareDownload.png', 'isMine': true},
    {'image': 'assets/images/appstoreDownload.png', 'isMine': false},
    {'image': 'assets/images/fakecall.png', 'isMine': true},
    {'image': 'assets/images/realcall.png', 'isMine': false}
  ];
  var size = 3;
  var cells = [];
  var totalCellsRevealed = 0;
  var totalMines = 0;
  bool warned = false;

  void generateGrid() {
    cells = [];
    totalCellsRevealed = 0;
    totalMines = 0;

    for (int i = 0; i < size; i++) {
      var row = [];
      for (int j = 0; j < size; j++) {
        final cell =
            CellModel(i, j, imagesMap[(i * 3) + j]['image'].toString());
        row.add(cell);
      }
      cells.add(row);
    }
  }

  Widget buildButton(CellModel cell) {
    return GestureDetector(
      onLongPress: () {
      },
      onTap: () {
        onTap(cell);
      },
      child: CellWidget(
        size: size,
        cell: cell,
      ),
    );
  }

  Row buildButtonRow(int column) {
    List<Widget> list = [];

    for (int i = 0; i < size; i++) {
      list.add(
        Expanded(
          child: buildButton(cells[i][column]),
        ),
      );
    }

    return Row(
      children: list,
    );
  }

  Column buildButtonColumn() {
    List<Widget> rows = [];

    for (int i = 0; i < size; i++) {
      rows.add(
        buildButtonRow(i),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: rows,
        ),
        LinearProgressIndicator(
          backgroundColor: Colors.white,
          value: totalCellsRevealed / (size * size - totalMines),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
        Expanded(
          child: SingleChildScrollView(
            primary: true,
            child: buildRules(),
          ),
        )
      ],
    );
  }

  Column buildRules() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Row(
            children: [
              // Expanded(
              //   child: RichText(
              //     text: TextSpan(
              //       children: rules
              //           .map(
              //             (e) => TextSpan(
              //                 text: e, style: TextStyle(color: Colors.black)),
              //           )
              //           .toList(),
              //     ),
              //     textAlign: TextAlign.start,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  void onTap(CellModel cell) async {
    // If the first tapped cell is a mine, regenerate the grid
    if (cell.isMine && totalCellsRevealed == 0) {
      while (imagesMap[(cell.x * 3) + cell.y]['isMine'] == true) {
        restart();
      }

      cell = cells[cell.x][cell.y];
    }

    if (imagesMap[(cell.x * 3) + cell.y]['isMine'] == true) {

      setState(() {
        score--;
      });
      final response = await warned == false
          ? showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Wrong Link"),
                content: Text("Information about wrong link. Last Warning ☠️"),
                actions: [
                  MaterialButton(
                    color: Colors.deepPurple,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("OK 😰"),
                  ),
                ],
              ),
            )
          : showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Game Over 🙃"),
                content: Text("Information about wrong link"),
                actions: [
                  MaterialButton(
                    color: Colors.deepPurple,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Adios"),
                  ),
                ],
              ),
            );

      if (warned) {
        setState(() {
          warned = false;
        });
        restart();
      } else {
        setState(() {
          warned = true;
        });
      }
      return;
    } else {
      setState(() {});
      if (checkIfPlayerWon()) {
        final response = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Congratulations"),
            content: Text(
                "You discovered all the tiles without stepping on any mines. Well done."),
            actions: [
              MaterialButton(
                color: Colors.deepPurple,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Next Level"),
              ),
            ],
          ),
        );

        if (response) {
          size++;
          restart();
        }
      } else {
        setState(() {
          score++;
        });
      }
    }
  }

  void restart() {
    score = 0;
    setState(() {
      generateGrid();
    });
  }

  bool checkIfPlayerWon() {
    if (totalCellsRevealed + totalMines == size * size) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    generateGrid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Perfect Game"),
        actions: [
          IconButton(
            icon: Text(score.toString()),
            onPressed: () => restart(),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(1.0),
        child: buildButtonColumn(),
      ),
    );
  }
}
