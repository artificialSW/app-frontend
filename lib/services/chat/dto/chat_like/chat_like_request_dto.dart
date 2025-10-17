import 'package:json_annotation/json_annotation.dart';

part 'chat_like_request_dto.g.dart';

enum ChatLikeType {
  @JsonValue('question')
  question,           // 개인질문
  @JsonValue('public_question')
  publicQuestion,     // 공통질문
  @JsonValue('comment')
  comment,            // 댓글
}

@JsonSerializable()
class ChatLikeRequestDto {
  @JsonKey(name: 'type')
  final ChatLikeType what;
  final int id;

  const ChatLikeRequestDto({
    required this.what,
    required this.id,
  });

  factory ChatLikeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChatLikeRequestDtoFromJson(json);


  Map<String, dynamic> toJson() => _$ChatLikeRequestDtoToJson(this);
}
