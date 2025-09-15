import 'package:artificialsw_frontend/services/puzzle/dto/get_archived_puzzle_list/puzzle_get_archived_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_completed_puzzle_list/puzzle_get_completed_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_get_archived_list_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleGetArchivedListDto {
  final List<PuzzleGetArchivedDataDto> archivedList;

  PuzzleGetArchivedListDto({
    required this.archivedList,
  });

  factory PuzzleGetArchivedListDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGetArchivedListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleGetArchivedListDtoToJson(this);
}
