import 'package:json_annotation/json_annotation.dart';

part 'puzzlepiece_position.g.dart';

@JsonSerializable()
class PuzzlePiecePosition {
  final double x;
  final double y;

  PuzzlePiecePosition({
    required this.x,
    required this.y,
  });

  factory PuzzlePiecePosition.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePiecePositionFromJson(json);

  Map<String, dynamic> toJson() => _$PuzzlePiecePositionToJson(this);
}
