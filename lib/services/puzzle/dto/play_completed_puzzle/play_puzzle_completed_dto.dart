import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_puzzle_completed_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PlayPuzzleCompletedDto {
  final String imageUrl;
  final int size;
  final String message;

  PlayPuzzleCompletedDto({
    required this.imageUrl,
    required this.size,
    required this.message,
  });

  factory PlayPuzzleCompletedDto.fromJson(Map<String, dynamic> json) =>
      _$PlayPuzzleCompletedDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayPuzzleCompletedDtoToJson(this);
}
