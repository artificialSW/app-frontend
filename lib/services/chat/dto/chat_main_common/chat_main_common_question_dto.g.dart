// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_main_common_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMainCommonQuestionDto _$ChatMainCommonQuestionDtoFromJson(
        Map<String, dynamic> json) =>
    ChatMainCommonQuestionDto(
      questionId: json['Q_id'] as String,
      content: json['content'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
    );

Map<String, dynamic> _$ChatMainCommonQuestionDtoToJson(
        ChatMainCommonQuestionDto instance) =>
    <String, dynamic>{
      'Q_id': instance.questionId,
      'content': instance.content,
      'likes': instance.likes,
      'comments': instance.comments,
    };
