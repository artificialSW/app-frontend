import 'package:json_annotation/json_annotation.dart';

part 'chat_weekly_common_question_dto.g.dart';

@JsonSerializable()
class ChatWeeklyCommonQuestionDto {
  final int questionId;
  final String questionContent;
  final int likes;
  final int posts;

  ChatWeeklyCommonQuestionDto({
    required this.questionId,
    required this.questionContent,
    required this.likes,
    required this.posts,
  });

  factory ChatWeeklyCommonQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatWeeklyCommonQuestionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatWeeklyCommonQuestionDtoToJson(this);
}








