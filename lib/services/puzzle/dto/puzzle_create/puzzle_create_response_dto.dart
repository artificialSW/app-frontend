import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_create_response_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PuzzleCreateResponseDto {
  final String puzzleId;
  final String imageUrl;
  final String createdAt;
  final String message;

  PuzzleCreateResponseDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.createdAt,
    required this.message,
  });

  factory PuzzleCreateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleCreateResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleCreateResponseDtoToJson(this);
}
