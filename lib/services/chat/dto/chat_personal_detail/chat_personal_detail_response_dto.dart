import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'chat_personal_detail_question_dto.dart';
import 'chat_personal_detail_comment_dto.dart';

part 'chat_personal_detail_response_dto.g.dart';

@JsonSerializable()
class ChatPersonalDetailResponseDto {
  final ChatPersonalDetailQuestionDto question;
  final List<ChatPersonalDetailCommentDto> comments;

  ChatPersonalDetailResponseDto({
    required this.question,
    required this.comments,
  });

  factory ChatPersonalDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonalDetailResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatPersonalDetailResponseDtoToJson(this);
}
