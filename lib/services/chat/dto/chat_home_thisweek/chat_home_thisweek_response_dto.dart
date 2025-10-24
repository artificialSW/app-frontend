import 'package:json_annotation/json_annotation.dart';
import 'chat_home_thisweek_comment_dto.dart';

part 'chat_home_thisweek_response_dto.g.dart';

@JsonSerializable()
class ChatHomeThisweekResponseDto {
  final String questions;
  @JsonKey(name: 'question_ref_id')
  final int questionRefId;
  final List<ChatHomeThisweekCommentDto> comments;
  final int unsolved;

  ChatHomeThisweekResponseDto({
    required this.questions,
    required this.questionRefId,
    required this.comments,
    required this.unsolved,
  });

  factory ChatHomeThisweekResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatHomeThisweekResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatHomeThisweekResponseDtoToJson(this);
}











