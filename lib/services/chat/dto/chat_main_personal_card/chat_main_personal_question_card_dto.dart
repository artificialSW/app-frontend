import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_main_personal_question_card_dto.g.dart';

@JsonSerializable()
class ChatMainPersonalQuestionCardDto {
  @JsonKey(name: 'Q_id')
  final int questionId;
  final String content;
  final int sender;
  final int receiver;
  @JsonKey(name: 'is_public')
  final bool isPublic;
  final bool solved;
  final int likes;
  @JsonKey(name: 'createAt')
  final String createdAt;

  ChatMainPersonalQuestionCardDto({
    required this.questionId,
    required this.content,
    required this.sender,
    required this.receiver,
    required this.isPublic,
    required this.solved,
    required this.likes,
    required this.createdAt,
  });

  factory ChatMainPersonalQuestionCardDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMainPersonalQuestionCardDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMainPersonalQuestionCardDtoToJson(this);
}
