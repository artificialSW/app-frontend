import 'package:flutter/material.dart';

// this class is used to clip the image to the puzzle piece path
class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePieceClipper(this.row, this.col, this.maxRow, this.maxCol);

  @override
  Path getClip(Size size) {
    return getPiecePath(size, row, col, maxRow, maxCol);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// this class is used to draw a border around the clipped image
class PuzzlePiecePainter extends CustomPainter {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePiecePainter(this.row, this.col, this.maxRow, this.maxCol);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x80FFFFFF) // Added const for Color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(getPiecePath(size, row, col, maxRow, maxCol), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// this is the path used to clip the image and, then, to draw a border around it; here we actually draw the puzzle piece
Path getPiecePath(Size size, int row, int col, int maxRow, int maxCol) {
  final width = size.width / maxCol;
  final height = size.height / maxRow;
  final offsetX = col * width;
  final offsetY = row * height;
  final bumpSize = height / 4;

  var path = Path();
  path.moveTo(offsetX, offsetY);

  if (row == 0) {
    // top side piece
    path.lineTo(offsetX + width, offsetY);
  } else {
    // top bump (위쪽 방향 돌출부)
    path.lineTo(offsetX + width / 3, offsetY);
    path.cubicTo(
        offsetX + width / 6,
        offsetY - bumpSize,
        offsetX + width / 6 * 5,
        offsetY - bumpSize,
        offsetX + width / 3 * 2,
        offsetY);
    path.lineTo(offsetX + width, offsetY);
  }

  if (col == maxCol - 1) {
    // right side piece
    path.lineTo(offsetX + width, offsetY + height);
  } else {
    // right bump (우측 방향 돌출부)
    path.lineTo(offsetX + width, offsetY + height / 3);
    path.cubicTo(
        offsetX + width - bumpSize,
        offsetY + height / 6,
        offsetX + width - bumpSize,
        offsetY + height / 6 * 5,
        offsetX + width,
        offsetY + height / 3 * 2);
    path.lineTo(offsetX + width, offsetY + height);
  }

  if (row != maxRow - 1) {
    // bottom side piece
    path.lineTo(offsetX + width / 3 * 2, offsetY + height);
    path.cubicTo(
        offsetX + width / 6 * 5,
        offsetY + height - bumpSize,
        offsetX + width / 6,
        offsetY + height - bumpSize,
        offsetX + width / 3,
        offsetY + height);
    path.lineTo(offsetX, offsetY + height);
  } else {
    // bottom bump
    path.lineTo(offsetX, offsetY + height);
  }


  if (col == 0) {
    // left side piece
    path.close();
  } else {
    // left bump
    path.lineTo(offsetX, offsetY + height / 3 * 2);
    path.cubicTo(
        offsetX - bumpSize,
        offsetY + height / 6 * 5,
        offsetX - bumpSize,
        offsetY + height / 6,
        offsetX,
        offsetY + height / 3);
    path.close();
  }

  return path;
}