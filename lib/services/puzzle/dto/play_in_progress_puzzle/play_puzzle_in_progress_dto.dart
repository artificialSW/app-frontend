import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_puzzle_in_progress_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PlayPuzzleInProgressDto {
  final String imageUrl;
  final int size;
  final Map<String, PiecePosition> pieces;
  final List<int>? completedPiecesId;

  PlayPuzzleInProgressDto({
    required this.imageUrl,
    required this.size,
    required this.pieces,
    this.completedPiecesId,
  });

  factory PlayPuzzleInProgressDto.fromJson(Map<String, dynamic> json) =>
      _$PlayPuzzleInProgressDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayPuzzleInProgressDtoToJson(this);
}
