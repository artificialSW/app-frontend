import 'package:json_annotation/json_annotation.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/personal_question_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/comments_dto.dart';


part 'personal_dto.g.dart';

/// 아카이브 꽃 데이터 응답 DTO
@JsonSerializable()
class PersonalDto {
  final PersonalQuestionDto question;
  final List<CommentsDto> comments;

  const PersonalDto({
    required this.question,
    required this.comments,
  });

  factory PersonalDto.fromJson(Map<String, dynamic> json) =>
  _$PersonalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalDtoToJson(this);
}
