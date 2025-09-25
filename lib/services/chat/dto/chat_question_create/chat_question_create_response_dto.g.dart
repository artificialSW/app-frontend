// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_question_create_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatQuestionCreateResponseDto _$ChatQuestionCreateResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ChatQuestionCreateResponseDto(
      questionId: json['questionId'] as int?,
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ChatQuestionCreateResponseDtoToJson(
        ChatQuestionCreateResponseDto instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'errorCode': instance.errorCode,
      'message': instance.message,
    };
