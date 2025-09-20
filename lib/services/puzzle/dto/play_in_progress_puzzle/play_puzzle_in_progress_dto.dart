import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_puzzle_in_progress_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PlayPuzzleInProgressDto {
  final String imageUrl;
  final int size;
  final bool youCanPlayPuzzle;
  final Map<String, PiecePosition> piecesPosition;

  PlayPuzzleInProgressDto({
    required this.imageUrl,
    required this.size,
    required this.youCanPlayPuzzle,
    required this.piecesPosition,
  });

  factory PlayPuzzleInProgressDto.fromJson(Map<String, dynamic> json) =>
      _$PlayPuzzleInProgressDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayPuzzleInProgressDtoToJson(this);
}
