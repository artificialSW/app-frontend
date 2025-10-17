import 'package:artificialsw_frontend/services/puzzle/dto/get_completed_puzzle_list/puzzle_get_completed_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_completed_list_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetCompletedListDto {
  final int puzzleId;
  final String imageUrl;
  final String category;
  final List<String> contributors;
  final String message;

  PuzzleGetCompletedListDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.category,
    required this.contributors,
    required this.message,
  });

  factory PuzzleGetCompletedListDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetCompletedListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetCompletedListDtoToJson(this);

  static List<PuzzleGetCompletedListDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PuzzleGetCompletedListDto.fromJson(json))
        .toList();
  }
}
