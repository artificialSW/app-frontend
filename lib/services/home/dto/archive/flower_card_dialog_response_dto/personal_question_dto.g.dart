// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalQuestionDto _$PersonalQuestionDtoFromJson(Map<String, dynamic> json) =>
    PersonalQuestionDto(
      question_ref_id: (json['question_ref_id'] as num).toInt(),
      content: json['content'] as String,
      sender: (json['sender'] as num).toInt(),
      sender_role: json['sender_role'] as String,
      likes: (json['likes'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      CreateAt: json['CreateAt'] as String,
    );

Map<String, dynamic> _$PersonalQuestionDtoToJson(
  PersonalQuestionDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.question_ref_id,
  'content': instance.content,
  'sender': instance.sender,
  'sender_role': instance.sender_role,
  'likes': instance.likes,
  'isLiked': instance.isLiked,
  'CreateAt': instance.CreateAt,
};
