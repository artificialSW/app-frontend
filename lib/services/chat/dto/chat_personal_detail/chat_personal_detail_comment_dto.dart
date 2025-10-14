import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_personal_detail_comment_dto.g.dart';

@JsonSerializable()
class ChatPersonalDetailCommentDto {
  final int commentId;
  final int writer;
  @JsonKey(name: 'writer_role')
  final String writerRole;
  final String content;
  final int likes;
  @JsonKey(name: 'isLiked', defaultValue: false)
  final bool isLiked;
  final List<ChatPersonalDetailCommentDto> reply;

  ChatPersonalDetailCommentDto({
    required this.commentId,
    required this.writer,
    required this.writerRole,
    required this.content,
    required this.likes,
    this.isLiked = false,
    required this.reply,
  });

  factory ChatPersonalDetailCommentDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonalDetailCommentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatPersonalDetailCommentDtoToJson(this);
}
