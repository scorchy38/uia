class CellModel {
  final int x;
  final int y;
  final String image;
  bool isMine = false;
  bool isRevealed = false;
  int value = 0;
  bool isFlagged = false;
  CellModel(this.x, this.y, this.image);
}
