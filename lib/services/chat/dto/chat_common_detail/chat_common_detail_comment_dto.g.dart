// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_common_detail_comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCommonDetailCommentDto _$ChatCommonDetailCommentDtoFromJson(
        Map<String, dynamic> json) =>
    ChatCommonDetailCommentDto(
      commentId: json['commentId'] as int,
      writer: json['writer'] as int,
      writerRole: json['writer_role'] as String,
      content: json['content'] as String,
      likes: json['likes'] as int,
      isLiked: json['isLiked'] as bool? ?? false,
      reply: (json['reply'] as List<dynamic>)
          .map((e) => ChatCommonDetailCommentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatCommonDetailCommentDtoToJson(
        ChatCommonDetailCommentDto instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'writer': instance.writer,
      'writer_role': instance.writerRole,
      'content': instance.content,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
      'reply': instance.reply,
    };
