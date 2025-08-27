// lib/views/puzzle_piece_painter.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// 퍼즐 조각의 모양을 정의하고 자르는 클래스
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

// 퍼즐 조각의 모양을 그리는 클래스 (이전과 동일)
class PuzzlePiecePainter extends CustomPainter {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePiecePainter(this.row, this.col, this.maxRow, this.maxCol);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x80FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(getPiecePath(size, row, col, maxRow, maxCol), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
Path getPiecePath(Size size, int row, int col, int maxRow, int maxCol) {
  final width = size.width; //여기 수정
  final height = size.height; //여기 수정
  final bumpSize = height / 4;
  final offsetX = 0.0;
  final offsetY = 0.0;

  var path = Path();
  path.moveTo(offsetX, offsetY);

  if (row == 0) {
    path.lineTo(offsetX + width, offsetY);
  } else {
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
    path.lineTo(offsetX + width, offsetY + height);
  } else {
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
    path.lineTo(offsetX, offsetY + height);
  }

  if (col == 0) {
    path.close();
  } else {
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

// 이 클래스가 원본 이미지를 잘라 그리는 역할을 합니다.
class PuzzleImagePainter extends CustomPainter {
  final ui.Image image;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzleImagePainter({
    required this.image,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pieceWidth = image.width / maxCol;
    final pieceHeight = image.height / maxRow;
    //final bump = pieceHeight / 4;
    //canvas.translate(bump, bump);
    final sourceRect = Rect.fromLTWH(
      col * pieceWidth,
      row * pieceHeight,
      pieceWidth,
      pieceHeight,
    );
    final destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, sourceRect, destinationRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}