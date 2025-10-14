// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_question_create_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatQuestionCreateRequestDto _$ChatQuestionCreateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    ChatQuestionCreateRequestDto(
      receiverId: json['receiverId'] as int,
      visibility: json['visibility'] as int,
      content: json['content'] as String,
    );

Map<String, dynamic> _$ChatQuestionCreateRequestDtoToJson(
        ChatQuestionCreateRequestDto instance) =>
    <String, dynamic>{
      'receiverId': instance.receiverId,
      'visibility': instance.visibility,
      'content': instance.content,
    };





