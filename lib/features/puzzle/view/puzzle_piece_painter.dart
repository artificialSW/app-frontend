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

// 퍼즐 조각의 테두리를 그리는 클래스
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

// 퍼즐 조각의 모양 Path 생성 함수 (변경 없음)
Path getPiecePath(Size size, int row, int col, int maxRow, int maxCol) {
  final width = size.width;
  final height = size.height;
  final bumpSize = height / 4;

  var path = Path();
  path.moveTo(0, 0);

  if (row == 0) {
    path.lineTo(width, 0);
  } else {
    path.lineTo(width / 3, 0);
    path.cubicTo(
        width / 6,
        -bumpSize,
        width / 6 * 5,
        -bumpSize,
        width / 3 * 2,
        0);
    path.lineTo(width, 0);
  }

  if (col == maxCol - 1) {
    path.lineTo(width, height);
  } else {
    path.lineTo(width, height / 3);
    path.cubicTo(
        width - bumpSize,
        height / 6,
        width - bumpSize,
        height / 6 * 5,
        width,
        height / 3 * 2);
    path.lineTo(width, height);
  }

  if (row != maxRow - 1) {
    path.lineTo(width / 3 * 2, height);
    path.cubicTo(
        width / 6 * 5,
        height - bumpSize,
        width / 6,
        height - bumpSize,
        width / 3,
        height);
    path.lineTo(0, height);
  } else {
    path.lineTo(0, height);
  }

  if (col == 0) {
    path.close();
  } else {
    path.lineTo(0, height / 3 * 2);
    path.cubicTo(
        -bumpSize,
        height / 6 * 5,
        -bumpSize,
        height / 6,
        0,
        height / 3);
    path.close();
  }
  return path;
}

// 원본 이미지를 조각의 모양에 맞춰 그리는 클래스 (수정됨)
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

    final sourceRect = Rect.fromLTWH(
      col * pieceWidth,
      row * pieceHeight,
      pieceWidth,
      pieceHeight,
    );

    // ✅ 조각 위젯의 실제 크기 전체를 쓰도록 destination 설정
    final destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, sourceRect, destinationRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
