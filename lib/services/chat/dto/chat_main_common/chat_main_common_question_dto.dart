import 'package:json_annotation/json_annotation.dart';

part 'chat_main_common_question_dto.g.dart';

@JsonSerializable()
class ChatMainCommonQuestionDto {
  @JsonKey(name: 'Q_id')
  final String questionId;
  final String content;
  final int likes;
  final int comments;

  const ChatMainCommonQuestionDto({
    required this.questionId,
    required this.content,
    required this.likes,
    required this.comments,
  });

  factory ChatMainCommonQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMainCommonQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMainCommonQuestionDtoToJson(this);
}
