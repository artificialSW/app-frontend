// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_main_common_question_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMainCommonQuestionCardDto _$ChatMainCommonQuestionCardDtoFromJson(
  Map<String, dynamic> json,
) => ChatMainCommonQuestionCardDto(
  questionRefId: (json['question_ref_id'] as num).toInt(),
  content: json['content'] as String,
  likes: (json['likes'] as num).toInt(),
  comments: (json['comments'] as num).toInt(),
  isLiked: json['isLiked'] as bool,
);

Map<String, dynamic> _$ChatMainCommonQuestionCardDtoToJson(
  ChatMainCommonQuestionCardDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.questionRefId,
  'content': instance.content,
  'likes': instance.likes,
  'comments': instance.comments,
  'isLiked': instance.isLiked,
};
