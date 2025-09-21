import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_completed_data_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetCompletedDataDto {
  final String puzzleId;
  final String imageUrl;
  final String category;
  final List<String> AIKeyword;
  final List<String> contributors;
  final String completedAt;
  final String message;



  PuzzleGetCompletedDataDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.category,
    required this.AIKeyword,
    required this.contributors,
    required this.completedAt,
    required this.message,
  });

  factory PuzzleGetCompletedDataDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetCompletedDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetCompletedDataDtoToJson(this);
}
