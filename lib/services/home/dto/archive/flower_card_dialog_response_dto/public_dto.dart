import 'package:json_annotation/json_annotation.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/comments_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/public_question_dto.dart';

part 'public_dto.g.dart';

/// 아카이브 꽃 데이터 응답 DTO
@JsonSerializable()
class PublicDto {
  final PublicQuestionDto question;
  final List<CommentsDto> comments;

  const PublicDto({
    required this.question,
    required this.comments,
  });

  factory PublicDto.fromJson(Map<String, dynamic> json) =>
      _$PublicDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PublicDtoToJson(this);
}
