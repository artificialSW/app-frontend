// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDto _$PersonalDtoFromJson(Map<String, dynamic> json) => PersonalDto(
  question: PersonalQuestionDto.fromJson(
    json['question'] as Map<String, dynamic>,
  ),
  comments:
      (json['comments'] as List<dynamic>)
          .map((e) => CommentsDto.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$PersonalDtoToJson(PersonalDto instance) =>
    <String, dynamic>{
      'question': instance.question,
      'comments': instance.comments,
    };
