import 'package:json_annotation/json_annotation.dart';

part 'chat_weekly_update_response_dto.g.dart';

@JsonSerializable()
class ChatWeeklyUpdateResponseDto {
  final String update;

  const ChatWeeklyUpdateResponseDto({
    required this.update,
  });

  factory ChatWeeklyUpdateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatWeeklyUpdateResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatWeeklyUpdateResponseDtoToJson(this);
}


