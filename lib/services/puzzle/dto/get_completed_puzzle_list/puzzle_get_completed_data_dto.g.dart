// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_completed_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetCompletedDataDto _$PuzzleGetCompletedDataDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetCompletedDataDto(
  puzzleId: json['puzzleId'] as String,
  imageUrl: json['imageUrl'] as String,
  contributors:
      (json['contributors'] as List<dynamic>).map((e) => e as String).toList(),
  completedAt: json['completedAt'] as String,
  AIKeyword:
      (json['AIKeyword'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String,
);

Map<String, dynamic> _$PuzzleGetCompletedDataDtoToJson(
  PuzzleGetCompletedDataDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'contributors': instance.contributors,
  'completedAt': instance.completedAt,
  'AIKeyword': instance.AIKeyword,
  'category': instance.category,
};
