// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_main_common_question_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMainCommonQuestionCardDto _$ChatMainCommonQuestionCardDtoFromJson(
        Map<String, dynamic> json) =>
    ChatMainCommonQuestionCardDto(
      questionRefId: json['question_ref_id'] as int,
      content: json['content'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$ChatMainCommonQuestionCardDtoToJson(
        ChatMainCommonQuestionCardDto instance) =>
    <String, dynamic>{
      'question_ref_id': instance.questionRefId,
      'content': instance.content,
      'likes': instance.likes,
      'comments': instance.comments,
      'isLiked': instance.isLiked,
    };
