// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_weekly_common_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatWeeklyCommonQuestionDto _$ChatWeeklyCommonQuestionDtoFromJson(
        Map<String, dynamic> json) =>
    ChatWeeklyCommonQuestionDto(
      questionId: json['questionId'] as int,
      questionContent: json['questionContent'] as String,
      likes: json['likes'] as int,
      posts: json['posts'] as int,
    );

Map<String, dynamic> _$ChatWeeklyCommonQuestionDtoToJson(
        ChatWeeklyCommonQuestionDto instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'questionContent': instance.questionContent,
      'likes': instance.likes,
      'posts': instance.posts,
    };





