import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_in_progress_data_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetInProgressDataDto {
  final String puzzleId;
  final String imageUrl;
  final List<String> contributors;
  //final String lastSavedAt;
  //final List<String> AIKeyword;
  final String category;
  final int completedPiecesCount;
  final int size;

  PuzzleGetInProgressDataDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.contributors,
    //required this.lastSavedAt,
    //required this.AIKeyword,
    required this.category,
    required this.completedPiecesCount,
    required this.size,
  });

  factory PuzzleGetInProgressDataDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetInProgressDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetInProgressDataDtoToJson(this);
}
