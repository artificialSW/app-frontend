import 'package:json_annotation/json_annotation.dart';

part 'chat_common_detail_question_dto.g.dart';

@JsonSerializable()
class ChatCommonDetailQuestionDto {
  @JsonKey(name: 'Q_id')
  final int questionId;
  final String content;
  final int likes;
  @JsonKey(name: 'CreateAt')
  final String createdAt;
  final int count;

  const ChatCommonDetailQuestionDto({
    required this.questionId,
    required this.content,
    required this.likes,
    required this.createdAt,
    required this.count,
  });

  factory ChatCommonDetailQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ChatCommonDetailQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCommonDetailQuestionDtoToJson(this);
}
