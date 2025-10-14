// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_home_thisweek_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHomeThisweekResponseDto _$ChatHomeThisweekResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ChatHomeThisweekResponseDto(
      questions: json['questions'] as String,
      questionRefId: json['question_ref_id'] as int,
      comments: (json['comments'] as List<dynamic>)
          .map((e) => ChatHomeThisweekCommentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      unsolved: json['unsolved'] as int,
    );

Map<String, dynamic> _$ChatHomeThisweekResponseDtoToJson(
        ChatHomeThisweekResponseDto instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'question_ref_id': instance.questionRefId,
      'comments': instance.comments,
      'unsolved': instance.unsolved,
    };


