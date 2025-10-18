import 'package:artificialsw_frontend/services/puzzle/dto/get_completed_puzzle_list/puzzle_get_completed_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_archived_list_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetArchivedListDto {
  final int puzzleId;
  final String imageUrl;
  final List<String> contributors;
  final String archivedAt;
  final String category;

  PuzzleGetArchivedListDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.contributors,
    required this.archivedAt,
    required this.category,
  });

  factory PuzzleGetArchivedListDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetArchivedListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetArchivedListDtoToJson(this);

  static List<PuzzleGetArchivedListDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PuzzleGetArchivedListDto.fromJson(json))
        .toList();
  }
}
