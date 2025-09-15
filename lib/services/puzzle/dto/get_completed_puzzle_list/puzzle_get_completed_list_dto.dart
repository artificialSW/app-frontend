import 'package:artificialsw_frontend/services/puzzle/dto/get_completed_puzzle_list/puzzle_get_completed_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_completed_list_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetCompletedListDto {
  final List<PuzzleGetCompletedDataDto> completedList;

  PuzzleGetCompletedListDto({
    required this.completedList,
  });

  factory PuzzleGetCompletedListDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetCompletedListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetCompletedListDtoToJson(this);
}
