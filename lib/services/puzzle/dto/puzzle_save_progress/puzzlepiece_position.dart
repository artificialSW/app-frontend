import 'package:json_annotation/json_annotation.dart';

part 'puzzlepiece_position.g.dart';

@JsonSerializable()
class PuzzlePiecePosition {
  final double row;
  final double col;

  PuzzlePiecePosition({
    required this.row,
    required this.col,
  });

  factory PuzzlePiecePosition.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePiecePositionFromJson(json);

  Map<String, dynamic> toJson() => _$PuzzlePiecePositionToJson(this);
}
