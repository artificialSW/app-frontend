import 'package:json_annotation/json_annotation.dart';

part 'progress_scores_response_dto.g.dart';

@JsonSerializable()
class ProgressScoresResponseDto {
  @JsonKey(name: 'puzzle_score')
  final int puzzleScore;
  @JsonKey(name: 'community_score')
  final int communityScore;

  const ProgressScoresResponseDto({
    required this.puzzleScore,
    required this.communityScore,
  });

  factory ProgressScoresResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressScoresResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressScoresResponseDtoToJson(this);
}
