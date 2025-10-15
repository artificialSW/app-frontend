import 'package:artificialsw_frontend/services/puzzle/dto/get_in_progress_puzzle_list/puzzle_get_in_progress_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_in_progress_list_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetInProgressListDto {
  final String puzzleId;
  final String imageUrl;
  final List<String> contributors;
  final String category;
  final int completedPiecesCount;
  final int size;


  PuzzleGetInProgressListDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.contributors,
    required this.category,
    required this.completedPiecesCount,
    required this.size,
  });

  factory PuzzleGetInProgressListDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetInProgressListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetInProgressListDtoToJson(this);

  static List<PuzzleGetInProgressListDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PuzzleGetInProgressListDto.fromJson(json))
        .toList();
  }
}
