// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_personal_detail_comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonalDetailCommentDto _$ChatPersonalDetailCommentDtoFromJson(
        Map<String, dynamic> json) =>
    ChatPersonalDetailCommentDto(
      commentId: json['commentId'] as int,
      writer: json['writer'] as String,
      content: json['content'] as String,
      likes: json['likes'] as int,
      isLiked: json['isLiked'] as bool,
      reply: (json['reply'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ChatPersonalDetailCommentDtoToJson(
        ChatPersonalDetailCommentDto instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'writer': instance.writer,
      'content': instance.content,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
      'reply': instance.reply,
    };
