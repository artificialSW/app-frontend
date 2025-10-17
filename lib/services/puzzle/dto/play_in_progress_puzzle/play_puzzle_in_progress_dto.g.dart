// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_puzzle_in_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayPuzzleInProgressDto _$PlayPuzzleInProgressDtoFromJson(
  Map<String, dynamic> json,
) => PlayPuzzleInProgressDto(
  imageUrl: json['imageUrl'] as String,
  size: (json['size'] as num).toInt(),
  pieces: (json['pieces'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, PiecePosition.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$PlayPuzzleInProgressDtoToJson(
  PlayPuzzleInProgressDto instance,
) => <String, dynamic>{
  'imageUrl': instance.imageUrl,
  'size': instance.size,
  'pieces': instance.pieces,
};
