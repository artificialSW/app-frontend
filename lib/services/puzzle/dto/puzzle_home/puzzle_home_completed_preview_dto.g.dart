// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_home_completed_preview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleHomeCompletedPreviewDto _$PuzzleHomeCompletedPreviewDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleHomeCompletedPreviewDto(
  puzzleId: (json['puzzleId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  size: (json['size'] as num).toInt(),
  title: json['title'] as String,
  completedAt: json['completedAt'] as String,
);

Map<String, dynamic> _$PuzzleHomeCompletedPreviewDtoToJson(
  PuzzleHomeCompletedPreviewDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'size': instance.size,
  'title': instance.title,
  'completedAt': instance.completedAt,
};
