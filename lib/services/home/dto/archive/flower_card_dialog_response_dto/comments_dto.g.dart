// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsDto _$CommentsDtoFromJson(Map<String, dynamic> json) => CommentsDto(
  commentId: (json['commentId'] as num).toInt(),
  writer: (json['writer'] as num).toInt(),
  writer_role: json['writer_role'] as String,
  content: json['content'] as String,
  likes: (json['likes'] as num).toInt(),
  isLiked: json['isLiked'] as bool,
  reply:
      (json['reply'] as List<dynamic>)
          .map((e) => CommentsDto.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CommentsDtoToJson(CommentsDto instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'writer': instance.writer,
      'writer_role': instance.writer_role,
      'content': instance.content,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
      'reply': instance.reply,
    };
