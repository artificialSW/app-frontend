import 'package:json_annotation/json_annotation.dart';

part 'chat_personal_answer_question_dto.g.dart';

@JsonSerializable()
class ChatPersonalAnswerQuestionDto {
  @JsonKey(name: 'question_ref_id')
  final int questionRefId;
  final String content;
  final int sender;
  final bool visibility;

  const ChatPersonalAnswerQuestionDto({
    required this.questionRefId,
    required this.content,
    required this.sender,
    required this.visibility,
  });

  factory ChatPersonalAnswerQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonalAnswerQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPersonalAnswerQuestionDtoToJson(this);
}
