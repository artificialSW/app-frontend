import 'package:json_annotation/json_annotation.dart';

part 'chat_like_request_dto.g.dart';

enum ChatLikeType {
  @JsonValue('question')
  question,
  @JsonValue('PQ')
  personalQuestion,
  @JsonValue('comment')
  comment,
}

@JsonSerializable()
class ChatLikeRequestDto {
  final ChatLikeType what;
  final String id;

  const ChatLikeRequestDto({
    required this.what,
    required this.id,
  });

  factory ChatLikeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChatLikeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatLikeRequestDtoToJson(this);
}
