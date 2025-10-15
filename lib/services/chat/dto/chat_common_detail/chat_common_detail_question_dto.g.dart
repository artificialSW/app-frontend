// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_common_detail_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCommonDetailQuestionDto _$ChatCommonDetailQuestionDtoFromJson(
  Map<String, dynamic> json,
) => ChatCommonDetailQuestionDto(
  questionRefId: (json['question_ref_id'] as num).toInt(),
  content: json['content'] as String,
  likes: (json['likes'] as num).toInt(),
  createdAt: json['CreateAt'] as String,
  count: (json['count'] as num).toInt(),
  isLiked: json['isLiked'] as bool? ?? false,
);

Map<String, dynamic> _$ChatCommonDetailQuestionDtoToJson(
  ChatCommonDetailQuestionDto instance,
) => <String, dynamic>{
  'question_ref_id': instance.questionRefId,
  'content': instance.content,
  'likes': instance.likes,
  'CreateAt': instance.createdAt,
  'count': instance.count,
  'isLiked': instance.isLiked,
};
