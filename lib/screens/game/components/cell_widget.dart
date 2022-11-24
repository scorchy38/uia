import 'package:flutter/material.dart';
import 'package:uia/screens/game/components/main_game.dart';

import 'cell.dart';

class CellWidget extends StatefulWidget {
  const CellWidget({
    Key? key,
    required this.size,
    required this.cell,
  }) : super(key: key);

  final int size;
  final CellModel cell;

  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 1, bottom: 1),
      height: MediaQuery.of(context).size.width / widget.size + 1,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: widget.cell.isRevealed
            ? (widget.cell.isMine
                ? Colors.red[100]
                : Colors.grey[200 + (widget.cell.value * 50)])
            : Colors.white,
      ),
      child: widget.cell.isRevealed
          ? imagesMap[(widget.cell.x * 3) + widget.cell.y]['isMine'] == true
              ? Container(
                  color: Colors.red,
                  height: 20,
                  width: 20,
                )
              : Container(
                  color: Colors.green,
                  height: 20,
                  width: 20,
                )
          : Center(child: Image.asset(widget.cell.image)),
    );
  }
}
