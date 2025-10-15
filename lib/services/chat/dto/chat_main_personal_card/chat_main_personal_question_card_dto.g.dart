// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_main_personal_question_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMainPersonalQuestionCardDto _$ChatMainPersonalQuestionCardDtoFromJson(
  Map<String, dynamic> json,
) => ChatMainPersonalQuestionCardDto(
  questionRefId: (json['question_ref_id'] as num).toInt(),
  content: json['content'] as String,
  sender: (json['sender'] as num).toInt(),
  receiver: (json['receiver'] as num).toInt(),
  visibility: (json['visibility'] as num).toInt(),
  likes: (json['likes'] as num).toInt(),
  comments: (json['comments'] as num).toInt(),
  isLiked: json['isLiked'] as bool,
);

Map<String, dynamic> _$ChatMainPersonalQuestionCardDtoToJson(
  ChatMainPersonalQuestionCardDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.questionRefId,
  'content': instance.content,
  'sender': instance.sender,
  'receiver': instance.receiver,
  'visibility': instance.visibility,
  'likes': instance.likes,
  'comments': instance.comments,
  'isLiked': instance.isLiked,
};
