import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_reply_request_dto.g.dart';

@JsonSerializable()
class ChatReplyRequestDto {
  final int questionRefId;
  final String content;
  final int? replyTo;

  ChatReplyRequestDto({
    required this.questionRefId,
    required this.content,
    this.replyTo,
  });

  factory ChatReplyRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChatReplyRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatReplyRequestDtoToJson(this);
}


