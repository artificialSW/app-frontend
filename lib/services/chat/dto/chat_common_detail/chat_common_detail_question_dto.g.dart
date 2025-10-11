// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_common_detail_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCommonDetailQuestionDto _$ChatCommonDetailQuestionDtoFromJson(
        Map<String, dynamic> json) =>
    ChatCommonDetailQuestionDto(
      questionId: json['Q_id'] as int,
      content: json['content'] as String,
      likes: json['likes'] as int,
      createdAt: json['CreateAt'] as String,
      count: json['count'] as int,
    );

Map<String, dynamic> _$ChatCommonDetailQuestionDtoToJson(
        ChatCommonDetailQuestionDto instance) =>
    <String, dynamic>{
      'Q_id': instance.questionId,
      'content': instance.content,
      'likes': instance.likes,
      'CreateAt': instance.createdAt,
      'count': instance.count,
    };



