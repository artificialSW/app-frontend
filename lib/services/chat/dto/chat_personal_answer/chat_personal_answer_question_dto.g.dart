// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_personal_answer_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonalAnswerQuestionDto _$ChatPersonalAnswerQuestionDtoFromJson(
        Map<String, dynamic> json) =>
    ChatPersonalAnswerQuestionDto(
      questionId: json['Q_id'] as String,
      content: json['content'] as String,
      sender: json['sender'] as int,
      receiver: json['receiver'] as int,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      solved: json['solved'] as bool,
      isPublic: json['is_public'] as bool,
    );

Map<String, dynamic> _$ChatPersonalAnswerQuestionDtoToJson(
        ChatPersonalAnswerQuestionDto instance) =>
    <String, dynamic>{
      'Q_id': instance.questionId,
      'content': instance.content,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'likes': instance.likes,
      'comments': instance.comments,
      'solved': instance.solved,
      'is_public': instance.isPublic,
    };
