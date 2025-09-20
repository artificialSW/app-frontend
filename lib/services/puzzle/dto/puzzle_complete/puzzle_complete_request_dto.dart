import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_complete_request_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleCompleteRequestDto {
  final String puzzleId;
  final String solverId;

  PuzzleCompleteRequestDto({
    required this.puzzleId,
    required this.solverId,
  });

  factory PuzzleCompleteRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleCompleteRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleCompleteRequestDtoToJson(this);
}
