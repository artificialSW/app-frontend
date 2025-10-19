import 'package:json_annotation/json_annotation.dart';

part 'public_question_dto.g.dart';

/// 아카이브 꽃 데이터 응답 DTO
@JsonSerializable()
class PublicQuestionDto {
  final int question_ref_id;
  final String content;
  final int likes;
  final bool isLiked;
  final String CreateAt;
  final int count;

  const PublicQuestionDto({
    required this.question_ref_id,
    required this.content,
    required this.likes,
    required this.isLiked,
    required this.CreateAt,
    required this.count,
  });

  factory PublicQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$PublicQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PublicQuestionDtoToJson(this);
}
