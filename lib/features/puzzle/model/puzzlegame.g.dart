// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzlegame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGame _$PuzzleGameFromJson(Map<String, dynamic> json) => PuzzleGame(
    puzzleId: (json['puzzleId'] as num).toInt(),
    imageUrl: json['imageUrl'] as String,
    size: (json['size'] as num?)?.toInt(),
    category: json['category'] as String,
    AIKeyword:
        (json['AIKeyword'] as List<dynamic>).map((e) => e as String).toList(),
    piecesPosition:
        (json['piecesPosition'] as List<dynamic>?)
            ?.map((e) => PiecePosition.fromJson(e as Map<String, dynamic>))
            .toList(),
    gameState: $enumDecodeNullable(_$GameStateEnumMap, json['gameState']),
    isArchived: json['isArchived'] ?? false,
    contributors:
        (json['contributors'] as List<dynamic>?)
            ?.map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList(),
  )
  ..completedPiecesId =
      (json['completedPiecesId'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList();

Map<String, dynamic> _$PuzzleGameToJson(PuzzleGame instance) =>
    <String, dynamic>{
      'puzzleId': instance.puzzleId,
      'imageUrl': instance.imageUrl,
      'size': instance.size,
      'category': instance.category,
      'AIKeyword': instance.AIKeyword,
      'piecesPosition': instance.piecesPosition,
      'completedPiecesId': instance.completedPiecesId,
      'gameState': _$GameStateEnumMap[instance.gameState]!,
      'contributors': instance.contributors,
      'isArchived': instance.isArchived,
    };

const _$GameStateEnumMap = {
  GameState.Unplayed: 'Unplayed',
  GameState.Ongoing: 'Ongoing',
  GameState.Completed: 'Completed',
};
