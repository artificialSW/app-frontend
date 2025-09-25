// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_main_personal_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMainPersonalQuestionDto _$ChatMainPersonalQuestionDtoFromJson(
        Map<String, dynamic> json) =>
    ChatMainPersonalQuestionDto(
      questionId: json['Q_id'] as String,
      content: json['content'] as String,
      sender: json['sender'] as int,
      receiver: json['receiver'] as int,
      isPublic: json['is_public'] as bool,
      solved: json['solved'] as bool,
      likes: json['likes'] as int,
      createdAt: json['createAt'] as String,
    );

Map<String, dynamic> _$ChatMainPersonalQuestionDtoToJson(
        ChatMainPersonalQuestionDto instance) =>
    <String, dynamic>{
      'Q_id': instance.questionId,
      'content': instance.content,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'is_public': instance.isPublic,
      'solved': instance.solved,
      'likes': instance.likes,
      'createAt': instance.createdAt,
    };
