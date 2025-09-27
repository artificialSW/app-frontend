import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'chat_personal_answer_question_dto.dart';

part 'chat_personal_answer_response_dto.g.dart';

@JsonSerializable()
class ChatPersonalAnswerResponseDto {
  @JsonKey(name: 'qusetions')
  final List<ChatPersonalAnswerQuestionDto> questions;

  ChatPersonalAnswerResponseDto({
    required this.questions,
  });

  factory ChatPersonalAnswerResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonalAnswerResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatPersonalAnswerResponseDtoToJson(this);
}
