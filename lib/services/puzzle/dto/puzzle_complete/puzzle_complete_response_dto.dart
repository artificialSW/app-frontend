import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_complete_response_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleCompleteResponseDto {
  final String puzzleId;
  final String message;
  final String fruitName;
  final String fruitMessage;
  final List<String> contributors;

  PuzzleCompleteResponseDto({
    required this.puzzleId,
    required this.message,
    required this.fruitName,
    required this.fruitMessage,
    required this.contributors,
  });

  factory PuzzleCompleteResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleCompleteResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleCompleteResponseDtoToJson(this);
}
