import 'package:flutter/material.dart';

class PuzzlePieceModel {
  final int id;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  final double pieceWidth; // 추가
  final double pieceHeight; // 추가

  Offset currentPosition;
  final Offset correctPosition;
  bool isPlaced = false;

  PuzzlePieceModel({
    required this.id,
    required this.imageSize,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
    required this.pieceWidth,
    required this.pieceHeight,
    required this.currentPosition,
    required this.correctPosition,
  });
}