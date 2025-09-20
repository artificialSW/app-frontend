import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_archived_data_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetArchivedDataDto {
  final String puzzleId;
  final String imageUrl;
  final List<String> contributors;
  final String archivedAt;
  final List<String> AIKeyword;
  final String category;

  PuzzleGetArchivedDataDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.contributors,
    required this.archivedAt,
    required this.AIKeyword,
    required this.category,
  });

  factory PuzzleGetArchivedDataDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetArchivedDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetArchivedDataDtoToJson(this);
}
