import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_reply_response_dto.g.dart';

@JsonSerializable()
class ChatReplyResponseDto {
  final String message;
  final int? replyId;

  ChatReplyResponseDto({
    required this.message,
    this.replyId,
  });

  factory ChatReplyResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatReplyResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatReplyResponseDtoToJson(this);
}





