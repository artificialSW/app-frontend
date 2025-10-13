import 'package:json_annotation/json_annotation.dart';

part 'chat_personal_detail_question_dto.g.dart';

@JsonSerializable()
class ChatPersonalDetailQuestionDto {
  @JsonKey(name: 'question_ref_id')
  final int questionRefId;
  final String content;
  final int sender;
  final int likes;
  @JsonKey(name: 'CreateAt')
  final String createdAt;
  @JsonKey(name: 'isLiked', defaultValue: false)
  final bool isLiked;

  ChatPersonalDetailQuestionDto({
    required this.questionRefId,
    required this.content,
    required this.sender,
    required this.likes,
    required this.createdAt,
    this.isLiked = false,
  });

  factory ChatPersonalDetailQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPersonalDetailQuestionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatPersonalDetailQuestionDtoToJson(this);
}


