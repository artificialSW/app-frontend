import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_create_request_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleCreateRequestDto {
  final int size;

  PuzzleCreateRequestDto({
    required this.size,
  });

  factory PuzzleCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleCreateRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleCreateRequestDtoToJson(this);
}
