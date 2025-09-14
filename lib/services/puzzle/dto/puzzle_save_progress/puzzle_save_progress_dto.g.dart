// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_save_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleSaveProgressDto _$PuzzleSaveProgressDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleSaveProgressDto(
  puzzleId: json['puzzleId'] as String,
  puzzleSize: (json['puzzleSize'] as num).toInt(),
  pieces: (json['pieces'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      int.parse(k),
      PuzzlePiecePosition.fromJson(e as Map<String, dynamic>),
    ),
  ),
  completedPiecesId:
      (json['completedPiecesId'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
  contributorId: json['contributorId'] as String,
  completed: json['completed'] as bool,
  isPlayingPuzzle: json['isPlayingPuzzle'] as bool,
);

Map<String, dynamic> _$PuzzleSaveProgressDtoToJson(
  PuzzleSaveProgressDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'puzzleSize': instance.puzzleSize,
  'pieces': instance.pieces.map((k, e) => MapEntry(k.toString(), e)),
  'completedPiecesId': instance.completedPiecesId,
  'contributorId': instance.contributorId,
  'completed': instance.completed,
  'isPlayingPuzzle': instance.isPlayingPuzzle,
};
