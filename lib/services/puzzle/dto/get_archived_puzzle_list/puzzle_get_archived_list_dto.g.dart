// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_archived_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetArchivedListDto _$PuzzleGetArchivedListDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetArchivedListDto(
  puzzleId: (json['puzzleId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  contributors:
      (json['contributors'] as List<dynamic>).map((e) => e as String).toList(),
  archivedAt: json['archivedAt'] as String,
  category: json['category'] as String,
);

Map<String, dynamic> _$PuzzleGetArchivedListDtoToJson(
  PuzzleGetArchivedListDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'contributors': instance.contributors,
  'archivedAt': instance.archivedAt,
  'category': instance.category,
};
