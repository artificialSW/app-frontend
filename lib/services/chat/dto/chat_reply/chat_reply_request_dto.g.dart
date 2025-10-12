// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reply_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReplyRequestDto _$ChatReplyRequestDtoFromJson(Map<String, dynamic> json) =>
    ChatReplyRequestDto(
      questionRefId: json['questionRefId'] as int,
      content: json['content'] as String,
      replyTo: json['replyTo'] as int?,
    );

Map<String, dynamic> _$ChatReplyRequestDtoToJson(
        ChatReplyRequestDto instance) =>
    <String, dynamic>{
      'questionRefId': instance.questionRefId,
      'content': instance.content,
      'replyTo': instance.replyTo,
    };




