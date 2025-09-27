import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_personal_detail_comment_dto.g.dart';

@JsonSerializable()
class ChatPersonalDetailCommentDto {
  final int commentId;
  final String writer;
  final String content;
  final int likes;
  final List<String> reply;

  ChatPersonalDetailCommentDto({
    required this.commentId,
    required this.writer,
    required this.content,
    required this.likes,
    required this.reply,
  });

  factory ChatPersonalDetailCommentDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonalDetailCommentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatPersonalDetailCommentDtoToJson(this);
}
