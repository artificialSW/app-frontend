import 'package:json_annotation/json_annotation.dart';

part 'chat_home_thisweek_comment_dto.g.dart';

@JsonSerializable()
class ChatHomeThisweekCommentDto {
  final int writer;
  final String contents;

  ChatHomeThisweekCommentDto({
    required this.writer,
    required this.contents,
  });

  factory ChatHomeThisweekCommentDto.fromJson(Map<String, dynamic> json) =>
      _$ChatHomeThisweekCommentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatHomeThisweekCommentDtoToJson(this);
}


