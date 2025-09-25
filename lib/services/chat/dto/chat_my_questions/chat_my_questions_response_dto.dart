import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../chat_main_personal/chat_main_personal_question_dto.dart';

part 'chat_my_questions_response_dto.g.dart';

@JsonSerializable()
class ChatMyQuestionsResponseDto {
  final List<ChatMainPersonalQuestionDto> questions;

  ChatMyQuestionsResponseDto({
    required this.questions,
  });

  factory ChatMyQuestionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMyQuestionsResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMyQuestionsResponseDtoToJson(this);
}
