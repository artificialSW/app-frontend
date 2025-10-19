// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicQuestionDto _$PublicQuestionDtoFromJson(Map<String, dynamic> json) =>
    PublicQuestionDto(
      question_ref_id: (json['question_ref_id'] as num).toInt(),
      content: json['content'] as String,
      likes: (json['likes'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      CreateAt: json['CreateAt'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$PublicQuestionDtoToJson(PublicQuestionDto instance) =>
    <String, dynamic>{
      'question_ref_id': instance.question_ref_id,
      'content': instance.content,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
      'CreateAt': instance.CreateAt,
      'count': instance.count,
    };
