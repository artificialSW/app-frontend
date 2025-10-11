import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_question_create_response_dto.g.dart';

@JsonSerializable()
class ChatQuestionCreateResponseDto {
  final int? questionId;
  final String? errorCode;
  final String? message;

  ChatQuestionCreateResponseDto({
    this.questionId,
    this.errorCode,
    this.message,
  });

  factory ChatQuestionCreateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatQuestionCreateResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatQuestionCreateResponseDtoToJson(this);

  // 성공 여부 확인 메서드
  bool get isSuccess => questionId != null;
}



