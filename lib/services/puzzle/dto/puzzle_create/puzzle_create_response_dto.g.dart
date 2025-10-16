// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_create_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleCreateResponseDto _$PuzzleCreateResponseDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleCreateResponseDto(
  puzzleId: (json['puzzleId'] as num).toInt(),
  imageURL: json['imageURL'] as String,
  category: json['category'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$PuzzleCreateResponseDtoToJson(
  PuzzleCreateResponseDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageURL': instance.imageURL,
  'category': instance.category,
  'message': instance.message,
};
