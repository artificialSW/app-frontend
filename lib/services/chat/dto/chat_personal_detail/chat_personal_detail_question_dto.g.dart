// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_personal_detail_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonalDetailQuestionDto _$ChatPersonalDetailQuestionDtoFromJson(
        Map<String, dynamic> json) =>
    ChatPersonalDetailQuestionDto(
      questionRefId: json['question_ref_id'] as int,
      content: json['content'] as String,
      sender: json['sender'] as int,
      likes: json['likes'] as int,
      createdAt: json['CreateAt'] as String,
      isLiked: json['isLiked'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatPersonalDetailQuestionDtoToJson(
        ChatPersonalDetailQuestionDto instance) =>
    <String, dynamic>{
      'question_ref_id': instance.questionRefId,
      'content': instance.content,
      'sender': instance.sender,
      'likes': instance.likes,
      'CreateAt': instance.createdAt,
      'isLiked': instance.isLiked,
    };


