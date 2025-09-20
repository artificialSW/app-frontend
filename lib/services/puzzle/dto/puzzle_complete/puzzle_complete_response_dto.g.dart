// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_complete_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleCompleteResponseDto _$PuzzleCompleteResponseDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleCompleteResponseDto(
  puzzleId: json['puzzleId'] as String,
  message: json['message'] as String,
  fruitName: json['fruitName'] as String,
  fruitMessage: json['fruitMessage'] as String,
  contributors:
      (json['contributors'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$PuzzleCompleteResponseDtoToJson(
  PuzzleCompleteResponseDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'message': instance.message,
  'fruitName': instance.fruitName,
  'fruitMessage': instance.fruitMessage,
  'contributors': instance.contributors,
};
