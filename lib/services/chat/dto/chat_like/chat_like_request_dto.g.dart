// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_like_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatLikeRequestDto _$ChatLikeRequestDtoFromJson(Map<String, dynamic> json) =>
    ChatLikeRequestDto(
      what: $enumDecode(_$ChatLikeTypeEnumMap, json['what']),
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$ChatLikeRequestDtoToJson(ChatLikeRequestDto instance) =>
    <String, dynamic>{
      'what': _$ChatLikeTypeEnumMap[instance.what]!,
      'id': instance.id,
    };

const _$ChatLikeTypeEnumMap = {
  ChatLikeType.question: 'question',
  ChatLikeType.publicQuestion: 'public_question',
  ChatLikeType.comment: 'comment',
};
