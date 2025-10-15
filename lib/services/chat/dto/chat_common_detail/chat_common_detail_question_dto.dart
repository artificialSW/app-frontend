import 'package:json_annotation/json_annotation.dart';

part 'chat_common_detail_question_dto.g.dart';

@JsonSerializable()
class ChatCommonDetailQuestionDto {
  @JsonKey(name: 'question_ref_id')
  final int questionRefId;
  final String content;
  final int likes;
  @JsonKey(name: 'CreateAt')
  final String createdAt;
  final int count;
  @JsonKey(name: 'isLiked', defaultValue: false)
  final bool isLiked;

  const ChatCommonDetailQuestionDto({
    required this.questionRefId,
    required this.content,
    required this.likes,
    required this.createdAt,
    required this.count,
    this.isLiked = false,
  });

  factory ChatCommonDetailQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatCommonDetailQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCommonDetailQuestionDtoToJson(this);
}





