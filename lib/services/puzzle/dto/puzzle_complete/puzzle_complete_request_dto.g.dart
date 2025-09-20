// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_complete_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleCompleteRequestDto _$PuzzleCompleteRequestDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleCompleteRequestDto(
  puzzleId: json['puzzleId'] as String,
  solverId: json['solverId'] as String,
);

Map<String, dynamic> _$PuzzleCompleteRequestDtoToJson(
  PuzzleCompleteRequestDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'solverId': instance.solverId,
};
