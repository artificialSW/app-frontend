// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_archived_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetArchivedDataDto _$PuzzleGetArchivedDataDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetArchivedDataDto(
  puzzleId: json['puzzleId'] as String,
  imageUrl: json['imageUrl'] as String,
  contributors:
      (json['contributors'] as List<dynamic>).map((e) => e as String).toList(),
  archivedAt: json['archivedAt'] as String,
  AIKeyword:
      (json['AIKeyword'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String,
);

Map<String, dynamic> _$PuzzleGetArchivedDataDtoToJson(
  PuzzleGetArchivedDataDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'contributors': instance.contributors,
  'archivedAt': instance.archivedAt,
  'AIKeyword': instance.AIKeyword,
  'category': instance.category,
};
