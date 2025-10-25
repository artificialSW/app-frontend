import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'chat_common_detail_question_dto.dart';
import 'chat_common_detail_comment_dto.dart';

part 'chat_common_detail_response_dto.g.dart';

@JsonSerializable()
class ChatCommonDetailResponseDto {
  final ChatCommonDetailQuestionDto question;
  final List<ChatCommonDetailCommentDto> comments;

  ChatCommonDetailResponseDto({
    required this.question,
    required this.comments,
  });

  factory ChatCommonDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatCommonDetailResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatCommonDetailResponseDtoToJson(this);
}













