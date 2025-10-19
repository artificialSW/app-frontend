import 'package:json_annotation/json_annotation.dart';

part 'personal_question_dto.g.dart';

/// 아카이브 꽃 데이터 응답 DTO
@JsonSerializable()
class PersonalQuestionDto {
  final int question_ref_id;
  final String content;
  final int sender;
  final String sender_role;
  final int likes;
  final bool isLiked;
  final String CreateAt;

  const PersonalQuestionDto({
    required this.question_ref_id,
    required this.content,
    required this.sender,
    required this.sender_role,
    required this.likes,
    required this.isLiked,
    required this.CreateAt,
  });

  factory PersonalQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$PersonalQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalQuestionDtoToJson(this);
}
