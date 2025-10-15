// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_personal_detail_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonalDetailQuestionDto _$ChatPersonalDetailQuestionDtoFromJson(
  Map<String, dynamic> json,
) => ChatPersonalDetailQuestionDto(
  questionRefId: (json['question_ref_id'] as num).toInt(),
  content: json['content'] as String,
  sender: (json['sender'] as num).toInt(),
  senderRole: json['sender_role'] as String,
  likes: (json['likes'] as num).toInt(),
  createdAt: json['CreateAt'] as String,
  isLiked: json['isLiked'] as bool? ?? false,
);

Map<String, dynamic> _$ChatPersonalDetailQuestionDtoToJson(
  ChatPersonalDetailQuestionDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.questionRefId,
  'content': instance.content,
  'sender': instance.sender,
  'sender_role': instance.senderRole,
  'likes': instance.likes,
  'CreateAt': instance.createdAt,
  'isLiked': instance.isLiked,
};
