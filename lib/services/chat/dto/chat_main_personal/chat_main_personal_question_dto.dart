import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_main_personal_question_dto.g.dart';

@JsonSerializable()
class ChatMainPersonalQuestionDto {
  @JsonKey(name: 'Q_id')
  final String questionId;
  final String content;
  final int sender;
  final int receiver;
  @JsonKey(name: 'is_public')
  final bool isPublic;
  final bool solved;
  final int likes;
  @JsonKey(name: 'createAt')
  final String createdAt;

  ChatMainPersonalQuestionDto({
    required this.questionId,
    required this.content,
    required this.sender,
    required this.receiver,
    required this.isPublic,
    required this.solved,
    required this.likes,
    required this.createdAt,
  });

  factory ChatMainPersonalQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMainPersonalQuestionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMainPersonalQuestionDtoToJson(this);
}
