import 'package:json_annotation/json_annotation.dart';

part 'chat_common_detail_comment_dto.g.dart';

@JsonSerializable()
class ChatCommonDetailCommentDto {
  final String commentId;
  final String writer;
  final String content;
  final int likes;
  final List<String> reply;

  const ChatCommonDetailCommentDto({
    required this.commentId,
    required this.writer,
    required this.content,
    required this.likes,
    required this.reply,
  });

  factory ChatCommonDetailCommentDto.fromJson(Map<String, dynamic> json) =>
      _$ChatCommonDetailCommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCommonDetailCommentDtoToJson(this);
}
