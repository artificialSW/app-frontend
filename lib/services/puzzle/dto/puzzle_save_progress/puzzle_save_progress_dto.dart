import 'dart:ui';

import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_save_progress/puzzlepiece_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_save_progress_dto.g.dart';

@JsonSerializable()
class PuzzleSaveProgressDto {
  final String puzzleId;
  final int puzzleSize;
  final Map<int, PuzzlePiecePosition> pieces; //piece id는 String로.
  final List<int> completedPiecesId;
  final String contributorId;
  final bool completed;
  final bool isPlayingPuzzle;

  PuzzleSaveProgressDto({
    required this.puzzleId,
    required this.puzzleSize,
    required this.pieces,
    required this.completedPiecesId,
    required this.contributorId,
    required this.completed,
    required this.isPlayingPuzzle,
  });

  factory PuzzleSaveProgressDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleSaveProgressDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleSaveProgressDtoToJson(this);

}