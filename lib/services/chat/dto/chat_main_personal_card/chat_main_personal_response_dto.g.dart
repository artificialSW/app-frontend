// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_main_personal_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMainPersonalResponseDto _$ChatMainPersonalResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ChatMainPersonalResponseDto(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => ChatMainPersonalQuestionCardDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      unsolved: json['unsolved'] as int,
    );

Map<String, dynamic> _$ChatMainPersonalResponseDtoToJson(
        ChatMainPersonalResponseDto instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'unsolved': instance.unsolved,
    };



