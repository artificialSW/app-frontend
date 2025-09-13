// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_create_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleCreateResponseDto _$PuzzleCreateResponseDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleCreateResponseDto(
  puzzleId: json['puzzleId'] as String,
  imageUrl: json['imageUrl'] as String,
  createdAt: json['createdAt'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$PuzzleCreateResponseDtoToJson(
  PuzzleCreateResponseDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt,
  'message': instance.message,
};
