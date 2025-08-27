import 'package:flutter/material.dart';

class PuzzlePieceModel {
  final int id;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow; //piece 요소는 아니지만 계산을 위해 필요
  final int maxCol; //piece 요소는 아니지만 계산을 위해 필요

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
    required this.currentPosition,
    required this.correctPosition,
  });
}