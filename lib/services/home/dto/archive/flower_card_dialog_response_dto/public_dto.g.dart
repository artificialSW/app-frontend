// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicDto _$PublicDtoFromJson(Map<String, dynamic> json) => PublicDto(
  question: PublicQuestionDto.fromJson(
    json['question'] as Map<String, dynamic>,
  ),
  comments:
      (json['comments'] as List<dynamic>)
          .map((e) => CommentsDto.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$PublicDtoToJson(PublicDto instance) => <String, dynamic>{
  'question': instance.question,
  'comments': instance.comments,
};
