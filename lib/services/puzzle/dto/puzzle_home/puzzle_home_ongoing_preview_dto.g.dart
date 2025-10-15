// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_home_ongoing_preview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleHomeOngoingPreviewDto _$PuzzleHomeOngoingPreviewDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleHomeOngoingPreviewDto(
  puzzleId: (json['puzzleId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  size: (json['size'] as num).toInt(),
  completedPiecesId:
      (json['completedPiecesId'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
  lastSavedAt: json['lastSavedAt'] as String?,
);

Map<String, dynamic> _$PuzzleHomeOngoingPreviewDtoToJson(
  PuzzleHomeOngoingPreviewDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'size': instance.size,
  'completedPiecesId': instance.completedPiecesId,
  'lastSavedAt': instance.lastSavedAt,
};
