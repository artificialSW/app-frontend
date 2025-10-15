// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reply_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReplyRequestDto _$ChatReplyRequestDtoFromJson(Map<String, dynamic> json) =>
    ChatReplyRequestDto(
      questionRefId: (json['question_ref_id'] as num).toInt(),
      content: json['content'] as String,
      replyTo: (json['replyTo'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatReplyRequestDtoToJson(
  ChatReplyRequestDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.questionRefId,
  'content': instance.content,
  'replyTo': instance.replyTo,
};
