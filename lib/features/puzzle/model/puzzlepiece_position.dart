import 'package:json_annotation/json_annotation.dart';
/// 퍼즐 조각의 위치 및 회전 정보를 저장하는 모델

part 'puzzlepiece_position.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PiecePosition {
  double x;
  double y;

  PiecePosition({
    required this.x,
    required this.y,
  });

  factory PiecePosition.fromJson(Map<String, dynamic> json) =>
      _$PiecePositionFromJson(json);
  Map<String, dynamic> toJson() => _$PiecePositionToJson(this);
}