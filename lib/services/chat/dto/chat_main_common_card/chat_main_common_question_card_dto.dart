import 'package:json_annotation/json_annotation.dart';

part 'chat_main_common_question_card_dto.g.dart';

@JsonSerializable()
class ChatMainCommonQuestionCardDto {
  @JsonKey(name: 'question_ref_id')
  final int questionRefId;
  final String content;
  final int likes;
  final int comments;
  @JsonKey(name: 'isLiked')
  final bool isLiked;

  const ChatMainCommonQuestionCardDto({
    required this.questionRefId,
    required this.content,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });

  factory ChatMainCommonQuestionCardDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMainCommonQuestionCardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMainCommonQuestionCardDtoToJson(this);
}
