// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_common_detail_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCommonDetailResponseDto _$ChatCommonDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => ChatCommonDetailResponseDto(
  question: ChatCommonDetailQuestionDto.fromJson(
    json['question'] as Map<String, dynamic>,
  ),
  comments:
      (json['comments'] as List<dynamic>)
          .map(
            (e) =>
                ChatCommonDetailCommentDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$ChatCommonDetailResponseDtoToJson(
  ChatCommonDetailResponseDto instance,
) => <String, dynamic>{
  'question': instance.question,
  'comments': instance.comments,
};


