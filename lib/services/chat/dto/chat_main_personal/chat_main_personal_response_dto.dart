import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'chat_main_personal_question_dto.dart';

part 'chat_main_personal_response_dto.g.dart';

@JsonSerializable()
class ChatMainPersonalResponseDto {
  final List<ChatMainPersonalQuestionDto> questions;
  final int unsolved;

  ChatMainPersonalResponseDto({
    required this.questions,
    required this.unsolved,
  });

  factory ChatMainPersonalResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMainPersonalResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMainPersonalResponseDtoToJson(this);
}
