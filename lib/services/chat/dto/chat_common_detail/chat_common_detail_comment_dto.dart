import 'package:json_annotation/json_annotation.dart';

part 'chat_common_detail_comment_dto.g.dart';

@JsonSerializable()
class ChatCommonDetailCommentDto {
  final int commentId;
  final int writer;
  final String content;
  final int likes;
  @JsonKey(name: 'isLiked', defaultValue: false)
  final bool isLiked;
  final List<ChatCommonDetailCommentDto> reply; // 대댓글 재귀 구조

  const ChatCommonDetailCommentDto({
    required this.commentId,
    required this.writer,
    required this.content,
    required this.likes,
    this.isLiked = false,
    required this.reply,
  });

  factory ChatCommonDetailCommentDto.fromJson(Map<String, dynamic> json) =>
      _$ChatCommonDetailCommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCommonDetailCommentDtoToJson(this);
}
