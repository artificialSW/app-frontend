import 'package:artificialsw_frontend/services/puzzle/dto/get_in_progress_puzzle_list/puzzle_get_in_progress_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_in_progress_list_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetInProgressListDto {
  final List<PuzzleGetInProgressDataDto> inProgressList;

  PuzzleGetInProgressListDto({
    required this.inProgressList,
  });

  factory PuzzleGetInProgressListDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetInProgressListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetInProgressListDtoToJson(this);
}
