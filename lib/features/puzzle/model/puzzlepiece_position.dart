import 'package:flutter/material.dart';

/// 퍼즐 조각의 위치 및 회전 정보를 저장하는 모델
class PiecePosition {
  double x;
  double y;

  PiecePosition({
    required this.x,
    required this.y,
  });
}