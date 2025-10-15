// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_personal_answer_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonalAnswerQuestionDto _$ChatPersonalAnswerQuestionDtoFromJson(
  Map<String, dynamic> json,
) => ChatPersonalAnswerQuestionDto(
  questionRefId: (json['question_ref_id'] as num).toInt(),
  content: json['content'] as String,
  sender: (json['sender'] as num).toInt(),
  senderRole: json['sender_role'] as String,
  visibility: json['visibility'] as bool,
);

Map<String, dynamic> _$ChatPersonalAnswerQuestionDtoToJson(
  ChatPersonalAnswerQuestionDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.questionRefId,
  'content': instance.content,
  'sender': instance.sender,
  'sender_role': instance.senderRole,
  'visibility': instance.visibility,
};
