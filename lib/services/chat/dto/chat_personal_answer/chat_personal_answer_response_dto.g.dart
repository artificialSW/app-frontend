// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_personal_answer_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonalAnswerResponseDto _$ChatPersonalAnswerResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ChatPersonalAnswerResponseDto(
      questions: (json['qusetions'] as List<dynamic>)
          .map((e) => ChatPersonalAnswerQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatPersonalAnswerResponseDtoToJson(
        ChatPersonalAnswerResponseDto instance) =>
    <String, dynamic>{
      'qusetions': instance.questions,
    };
