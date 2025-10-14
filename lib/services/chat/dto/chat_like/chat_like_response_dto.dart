import 'package:json_annotation/json_annotation.dart';

part 'chat_like_response_dto.g.dart';

@JsonSerializable()
class ChatLikeResponseDto {
  @JsonKey(name: 'isLiked')
  final bool isLiked;
  @JsonKey(name: 'totalLikes')
  final int totalLikes;

  const ChatLikeResponseDto({
    required this.isLiked,
    required this.totalLikes,
  });

  factory ChatLikeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatLikeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatLikeResponseDtoToJson(this);
}
