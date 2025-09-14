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
  category: json['category'] as String,
  AIKeyword:
      (json['AIKeyword'] as List<dynamic>).map((e) => e as String).toList(),
  createdAt: json['createdAt'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$PuzzleCreateResponseDtoToJson(
  PuzzleCreateResponseDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'category': instance.category,
  'AIKeyword': instance.AIKeyword,
  'createdAt': instance.createdAt,
  'message': instance.message,
};
