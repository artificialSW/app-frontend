import 'package:json_annotation/json_annotation.dart';

part 'comments_dto.g.dart';

/// 아카이브 꽃 데이터 응답 DTO
@JsonSerializable()
class CommentsDto {
  final int commentId;
  final int writer;
  final String writer_role;
  final String content;
  final int likes;
  final bool isLiked;
  final List<CommentsDto> reply;

  const CommentsDto({
    required this.commentId,
    required this.writer,
    required this.writer_role,
    required this.content,
    required this.likes,
    required this.isLiked,
    required this.reply,
  });

  factory CommentsDto.fromJson(Map<String, dynamic> json) =>
      _$CommentsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsDtoToJson(this);

  static List<CommentsDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CommentsDto.fromJson(json))
        .toList();
  }
}
