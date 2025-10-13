import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_main_personal_question_card_dto.g.dart';

@JsonSerializable()
class ChatMainPersonalQuestionCardDto {
  @JsonKey(name: 'question_ref_id')
  final int questionRefId;
  final String content;
  final int sender;
  final int receiver;
  final int visibility;
  final int likes;
  final int comments;
  @JsonKey(name: 'isLiked')
  final bool isLiked;

  ChatMainPersonalQuestionCardDto({
    required this.questionRefId,
    required this.content,
    required this.sender,
    required this.receiver,
    required this.visibility,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });

  factory ChatMainPersonalQuestionCardDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMainPersonalQuestionCardDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMainPersonalQuestionCardDtoToJson(this);
}
