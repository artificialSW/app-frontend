// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_personal_detail_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPersonalDetailResponseDto _$ChatPersonalDetailResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ChatPersonalDetailResponseDto(
      question: ChatMainPersonalQuestionDto.fromJson(
          json['question'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => ChatPersonalDetailCommentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatPersonalDetailResponseDtoToJson(
        ChatPersonalDetailResponseDto instance) =>
    <String, dynamic>{
      'question': instance.question,
      'comments': instance.comments,
    };
