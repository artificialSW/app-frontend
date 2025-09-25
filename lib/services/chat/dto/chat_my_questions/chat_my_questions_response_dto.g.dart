// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_my_questions_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMyQuestionsResponseDto _$ChatMyQuestionsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ChatMyQuestionsResponseDto(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => ChatMainPersonalQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatMyQuestionsResponseDtoToJson(
        ChatMyQuestionsResponseDto instance) =>
    <String, dynamic>{
      'questions': instance.questions,
    };
