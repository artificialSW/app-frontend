import 'package:json_annotation/json_annotation.dart';

part 'chat_personal_answer_question_dto.g.dart';

@JsonSerializable()
class ChatPersonalAnswerQuestionDto {
  @JsonKey(name: 'Q_id')
  final String questionId;
  final String content;
  final int sender;
  final int receiver;
  final int likes;
  final int comments;
  final bool solved;
  @JsonKey(name: 'is_public')
  final bool isPublic;

  const ChatPersonalAnswerQuestionDto({
    required this.questionId,
    required this.content,
    required this.sender,
    required this.receiver,
    required this.likes,
    required this.comments,
    required this.solved,
    required this.isPublic,
  });

  factory ChatPersonalAnswerQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonalAnswerQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPersonalAnswerQuestionDtoToJson(this);
}
