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

  factory PuzzlePiecePosition.fromJson(Map<String, dynamic> json) {
    return PuzzlePiecePosition(
      row: (json['x'] as num).toDouble(),
      col: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'x': row,
    'y': col,
  };
}
