import 'package:flutter/material.dart';

class PuzzlePieceModel {
  final int id;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow; //piece 요소는 아니지만 계산을 위해 필요
  final int maxCol; //piece 요소는 아니지만 계산을 위해 필요
  final double pieceWidth; // 근데 이것도 조각마다 다 똑같지 않나? 그냥 따로 빼도 되지않나 리팩토링할때
  final double pieceHeight; // 근데 이것도 조각마다 다 똑같지 않나? 그냥 따로 빼도 되지않나 리팩토링할때

  Offset currentPosition; //(dx, dy)
  final Offset correctPosition; //(dx, dy)
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