// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_in_progress_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetInProgressListDto _$PuzzleGetInProgressListDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetInProgressListDto(
  puzzleId: (json['puzzleId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  contributors:
      (json['contributors'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String,
  completedPiecesCount: (json['completedPiecesCount'] as num).toInt(),
  size: (json['size'] as num).toInt(),
);

Map<String, dynamic> _$PuzzleGetInProgressListDtoToJson(
  PuzzleGetInProgressListDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'contributors': instance.contributors,
  'category': instance.category,
  'completedPiecesCount': instance.completedPiecesCount,
  'size': instance.size,
};
