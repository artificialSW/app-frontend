// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_question_create_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatQuestionCreateResponseDto _$ChatQuestionCreateResponseDtoFromJson(
  Map<String, dynamic> json,
) => ChatQuestionCreateResponseDto(
  questionRefId: (json['question_ref_id'] as num?)?.toInt(),
  errorCode: json['errorCode'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ChatQuestionCreateResponseDtoToJson(
  ChatQuestionCreateResponseDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.questionRefId,
  'errorCode': instance.errorCode,
  'message': instance.message,
};
