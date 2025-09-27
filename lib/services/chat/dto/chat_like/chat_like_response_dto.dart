import 'package:json_annotation/json_annotation.dart';

part 'chat_like_response_dto.g.dart';

@JsonSerializable()
class ChatLikeResponseDto {
  final bool success;

  const ChatLikeResponseDto({
    required this.success,
  });

  factory ChatLikeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatLikeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatLikeResponseDtoToJson(this);
}
