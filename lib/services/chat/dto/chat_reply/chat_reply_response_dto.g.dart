// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reply_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReplyResponseDto _$ChatReplyResponseDtoFromJson(Map<String, dynamic> json) =>
    ChatReplyResponseDto(
      success: json['success'] as bool,
      message: json['message'] as String,
      replyId: json['replyId'] as int?,
    );

Map<String, dynamic> _$ChatReplyResponseDtoToJson(
        ChatReplyResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'replyId': instance.replyId,
    };




