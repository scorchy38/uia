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
  final rules = [
    "Rules",
    "\n\nA player taps on a cell to uncover it. If a player uncovers a mined cell, the game ends, as there is only 1 life per game.",
    "\n\nOtherwise, the uncovered cells displays either a number, indicating the quantity of mines diagonally and/or adjacent to it, or a blank tile (or \"0\"), and all adjacent non-mined cells will automatically be uncovered.",
    "\n\nTap-and-hold on a cell will flag it, causing a flag to appear on it. Flagged cells are still considered covered.",
    "\n\nTo win the game, players must uncover all non-mine cells, at which point,",
  ];
  var size = 4;
  var cells = [];
  var totalCellsRevealed = 0;
  var totalMines = 0;

  void generateGrid() {
    cells = [];
    totalCellsRevealed = 0;
    totalMines = 0;

    for (int i = 0; i < size; i++) {
      var row = [];
      for (int j = 0; j < size; j++) {
        final cell = CellModel(i, j);
        row.add(cell);
      }
      cells.add(row);
    }

    // Marking mines
    for (int i = 0; i < size; ++i) {
      cells[Random().nextInt(size)][Random().nextInt(size)].isMine = true;
    }

    // Counting mines
    for (int i = 0; i < cells.length; ++i) {
      for (int j = 0; j < cells[i].length; ++j) {
        if (cells[i][j].isMine) totalMines++;
      }
    }

    // Updating values of cells in Moore's neighbourhood of mines
    for (int i = 0; i < cells.length; ++i) {
      for (int j = 0; j < cells[i].length; ++j) {
        if (cells[i][j].isMine) {
          createInitialNumbersAroundMine(cells[i][j]);
        }
      }
    }
  }

  Widget buildButton(CellModel cell) {
    return GestureDetector(
      onLongPress: () {
        markFlagged(cell);
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
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: rules
                        .map(
                          (e) => TextSpan(
                        text: e,
                            style: TextStyle(color: Colors.black)

                      ),
                    )
                        .toList(),
                  ),

                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void createInitialNumbersAroundMine(CellModel cell) {
    // print("Checking mine at " + cell.x.toString() + ", " + cell.y.toString());
    int xStart = (cell.x - 1) < 0 ? 0 : (cell.x - 1);
    int xEnd = (cell.x + 1) > (size - 1) ? (size - 1) : (cell.x + 1);

    int yStart = (cell.y - 1) < 0 ? 0 : (cell.y - 1);
    int yEnd = (cell.y + 1) > (size - 1) ? (size - 1) : (cell.y + 1);

    for (int i = xStart; i <= xEnd; ++i) {
      for (int j = yStart; j <= yEnd; ++j) {
        if (!cells[i][j].isMine) {
          cells[i][j].value++;
        }
      }
    }
  }

  void markFlagged(CellModel cell) {
    cell.isFlagged = !cell.isFlagged;
    setState(() {});
  }

  void onTap(CellModel cell) async {
    // If the first tapped cell is a mine, regenerate the grid
    if (cell.isMine && totalCellsRevealed == 0) {
      while (cells[cell.x][cell.y].isMine == true) {
        restart();
      }

      cell = cells[cell.x][cell.y];
    }

    if (cell.isMine) {
      unrevealRecursively(cell);
      setState(() {});
      final response = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Game Over"),
          content: Text("You stepped on a mine. Be careful next time."),
          actions: [
            MaterialButton(
              color: Colors.deepPurple,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Restart"),
            ),
          ],
        ),
      );

      if (response) {
        restart();
      }
      return;
    } else {
      unrevealRecursively(cell);
      setState(() {});
      if (checkIfPlayerWon()) {
        final response = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Congratulations"),
            content: Text("You discovered all the tiles without stepping on any mines. Well done."),
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
        setState(() {});
      }
    }
  }

  void restart() {
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

  void unrevealRecursively(CellModel cell) {
    if (cell.x > size || cell.y > size || cell.x < 0 || cell.y < 0 || cell.isRevealed) {
      return;
    }

    cell.isRevealed = true;
    totalCellsRevealed++;

    if (cell.value == 0) {
      int xStart = (cell.x - 1) < 0 ? 0 : (cell.x - 1);
      int xEnd = (cell.x + 1) > (size - 1) ? (size - 1) : (cell.x + 1);

      int yStart = (cell.y - 1) < 0 ? 0 : (cell.y - 1);
      int yEnd = (cell.y + 1) > (size - 1) ? (size - 1) : (cell.y + 1);

      for (int i = xStart; i <= xEnd; ++i) {
        for (int j = yStart; j <= yEnd; ++j) {
          if (!cells[i][j].isMine && !cells[i][j].isRevealed && cells[i][j].value == 0) {
            unrevealRecursively(cells[i][j]);
          }
        }
      }
    } else {
      return;
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
        title: Text("Minesweeper"),
        actions: [
          IconButton(
            icon: Icon(Icons.fiber_new),
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
