// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzlepiece_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzlePiecePosition _$PuzzlePiecePositionFromJson(Map<String, dynamic> json) =>
    PuzzlePiecePosition(
      row: (json['row'] as num).toInt(),
      col: (json['col'] as num).toInt(),
    );

Map<String, dynamic> _$PuzzlePiecePositionToJson(
  PuzzlePiecePosition instance,
) => <String, dynamic>{'row': instance.row, 'col': instance.col};
