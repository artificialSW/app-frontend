import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_question_create_request_dto.g.dart';

@JsonSerializable()
class ChatQuestionCreateRequestDto {
  final int receiverId;
  final int visibility;
  final String content;

  ChatQuestionCreateRequestDto({
    required this.receiverId,
    required this.visibility,
    required this.content,
  });

  factory ChatQuestionCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChatQuestionCreateRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatQuestionCreateRequestDtoToJson(this);
}





