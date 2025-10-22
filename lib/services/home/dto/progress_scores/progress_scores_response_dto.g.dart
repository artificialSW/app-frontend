// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_scores_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressScoresResponseDto _$ProgressScoresResponseDtoFromJson(
  Map<String, dynamic> json,
) => ProgressScoresResponseDto(
  puzzleScore: (json['puzzle_score'] as num).toInt(),
  communityScore: (json['community_score'] as num).toInt(),
);

Map<String, dynamic> _$ProgressScoresResponseDtoToJson(
  ProgressScoresResponseDto instance,
) => <String, dynamic>{
  'puzzle_score': instance.puzzleScore,
  'community_score': instance.communityScore,
};
